-- [TODO) Start Adding Weapons

-- Weapon.server.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local DamageIndict = require(ReplicatedStorage.Classes.WeaponClass.DamageIndict)

local AttackRE = ReplicatedStorage.RemoteEvents.Attack

local TInfo = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)

local cooldown = {}

-- // Functions
local function iceMagic(player, mouse: Mouse, capability)
	if not table.find(cooldown, player) then
		table.insert(cooldown, player)
		local iceShard = ServerStorage.Assets.IceShard
		local start = CFrame.new(player.Character.HumanoidRootPart.Position, mouse.Hit)
		-- local goal = start.LookVector * 70

		local shardsNum = math.random(9, 20)
		local shardIncrements = 70 / shardsNum
		for i = 1, shardsNum do
			local newShard: MeshPart = iceShard:Clone()
			newShard.Anchored = true
			newShard.CanCollide = false
			-- A buncha math
			local x, y, z = math.random(30, 50) / 30 * i, math.random(30, 50) / 30 * i * 2, math.random(30, 50) / 30 * i
			newShard.Size = Vector3.new(0, 0, 0)
			newShard.Orientation = Vector3.new(math.random(-30, 30), math.random(-180, 180), math.random(-30, 30))

			local pos = player.Character.HumanoidRootPart.Position + start.LookVector * (shardIncrements * i)
			newShard.Position = Vector3.new(pos.X, 0, pos.Z)

			local newSize = Vector3.new(x, y, z)
			local newPos = newShard.Position + Vector3.new(0, y / 2.5, 0)

			TweenService:Create(newShard, TInfo, { Size = newSize, Position = newPos }):Play()

			newShard.Parent = game.Workspace
			newShard.Touched:Connect(function(otherPart)
				if otherPart.Parent ~= player then
					local otherPlayer = Players:GetPlayerFromCharacter(otherPart.Parent)
					if otherPlayer then
						DamageIndict(otherPlayer, capability)
					end
				end
			end)
			coroutine.resume(coroutine.create(function()
				task.wait(3)
				local reverseTween = TweenService:Create(
					newShard,
					TInfo,
					{ Size = Vector3.new(0, 0, 0), Position = Vector3.new(pos.X, 0, pos.Z) }
				)
				reverseTween:Play()
				reverseTween.Completed:Wait()
				newShard:Destroy()
			end))
			task.wait(math.random(1, 100) / 1000)
			if i == #shardsNum then
				table.remove(cooldown, player)
			end
		end
	end
end

local function chooseFunction(player, mouse: Mouse, capability, name: string)
	print(name)
	if name == "Frost" then
		iceMagic(player, mouse, capability)
	end
end

AttackRE.OnServerEvent:Connect(chooseFunction)
