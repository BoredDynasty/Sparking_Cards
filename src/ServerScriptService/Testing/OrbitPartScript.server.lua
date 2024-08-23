--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local part = Workspace.CardTypes.CardBackItem
if not part then
	warn("CardBackItem not found in Workspace")
	return
end

local orbitRadius = 10
local orbitSpeed = 1

local function createOrbitingPart(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")

	local function updateOrbit()
		while character.Parent do
			local currentTime = tick()
			local angle = currentTime * orbitSpeed
			local offset = Vector3.new(math.cos(angle) * orbitRadius, 0, math.sin(angle) * orbitRadius)
			local targetCFrame = hrp.CFrame + offset
			part:PivotTo(targetCFrame)
			task.wait(0.1)
		end
	end

	coroutine.wrap(updateOrbit)()
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		createOrbitingPart(character)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in Players:GetPlayers() do
	if player.Character then
		createOrbitingPart(player.Character)
	end
	player.CharacterAdded:Connect(function(character)
		createOrbitingPart(character)
	end)
end
