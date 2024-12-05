--!strict

-- Fire.lua

-- // Requires -- //

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local Visualize = require(ServerStorage.Modules.Visualize)

return function(player: Player, asset: BasePart, raycast: RaycastResult)
	asset:SetNetworkOwnershipAuto()
	local animationID = "rbxassetid://0" -- [TODO) Replace this
	local animation = Instance.new("Animation")
	animation.AnimationId = animationID
	local character = player.Character or player.CharacterAdded:Wait()
	local animTrack = character:FindFirstChildOfClass("Animator"):LoadAnimation(animation)
	if raycast:FindFirstChildOfClass("Model") then
		local otherPlayer = Players:GetPlayerFromCharacter(raycast:FindFirstChildOfClass("Model"))
		if otherPlayer then
			local otherCharacter = otherPlayer.Character or otherPlayer.CharacterAdded:Wait()
			local targetPos = otherCharacter:FindFirstChild("HumanoidRootPart")
			task.defer(Visualize, targetPos.CFrame.Position, 5, asset)
			animTrack:Stop(0.5)
		end
	end
end
