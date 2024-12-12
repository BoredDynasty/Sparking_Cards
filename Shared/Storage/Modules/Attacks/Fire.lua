--!strict

-- Fire.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local DamageIndict = require(ReplicatedStorage.Classes.WeaponClass.DamageIndict)

return function(player, DAMAGE, FIREBALL_SPEED)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	-- Create the fireball
	local fireball: BasePart = ServerStorage.Assets:FindFirstChild("FireBall")
	fireball.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)

	task.spawn(function()
		task.delay(1.5, function()
			-- Add fireball velocity
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.LookVector * FIREBALL_SPEED
			bodyVelocity.Parent = fireball

			local size = Vector3.new(15, 15, 15)
			local region = Region3.new(fireball.Position - size, fireball.Position + size)
			local partsInRegion = game.Workspace:FindPartsInRegion3(region, nil, math.huge)
			for _, instance in pairs(partsInRegion) do
				local character = instance.Parent
				if character:FindFirstChild("Humanoid") and character.Name ~= character.Name then
					DamageIndict(player, DAMAGE, true)
				end
			end

			for _, particle: ParticleEmitter in fireball:GetDescendants() do
				for _, emitCount: number in particle:GetAttribute("EmitCount") do
					particle:Emit(emitCount)
				end
			end
		end)
	end)

	-- Cleanup after a few seconds
	game:GetService("Debris"):AddItem(fireball, 5)
end
