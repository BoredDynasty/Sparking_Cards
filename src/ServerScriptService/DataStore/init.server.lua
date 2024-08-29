--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local DataClass = require(ReplicatedStorage.Classes.DataStoreClass)
local AnalyticsClass = require(ReplicatedStorage.Classes.AnalyticsClass)
local RewardsClass = require(ReplicatedStorage.Classes.RewardsClass)

-- datastores are now modulized

Players.PlayerAdded:Connect(function(player)
	DataClass.PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataClass.PlayerRemoving(player)
	local Event = AnalyticsClass.LogCustomEvent(player, "Player Leaving")
	if Event ~= "Log Sent" then
		PostClass.PostAsync("Failed To Send Analytics | ", player.Name, nil, 10038562)
	end
end)

game:BindToClose(DataClass.StartBindToClose)
