--!strict

-- Fire.lua

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DamageIndict = require(ReplicatedStorage.Classes.WeaponClass.DamageIndict)

return function(asset, mouse, player, capability, TInfo)
	local iceShard = asset
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
		if i == shardsNum then -- #shardsNum
			return
		end
		return shardsNum, i
	end
end
