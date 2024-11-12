--!nocheck

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SafeTeleporter = require(ReplicatedStorage.Modules.SafeTeleporter)

local places = {
	["Match"] = 90845913624517,
}

Players.PlayerAdded:Connect(function(player: Player)
	player.Chatted:Connect(function(message)
		if string.find(message, "@match") then
			SafeTeleporter(player, places[1])
		end
	end)
end)
