--!nocheck
--!nolint

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Mouse = Players.LocalPlayer:GetMouse()

local places = {
	["Match"] = 90845913624517,
}

-- Gloves

Players.PlayerAdded:Connect(function(player: Player)
	player.Chatted:Connect(function(message)
		if string.find(message, "@match") then
			ReplicatedStorage.RemoteEvents.JoinQueueEvent:InvokeServer({ player }, places["Match"])
		elseif string.find(message, "@explore") then
			ReplicatedStorage.RemoteEvents.JoinQueueEvent:InvokeServer({ player }, places["Explore"])
		end
	end)
end)
