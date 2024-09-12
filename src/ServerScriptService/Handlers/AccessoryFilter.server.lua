--!strict
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

type Pair<A, B> = {
	A: A,
	B: B,
	P: Player,
}

Players.PlayerAdded:Connect(function(player)
	for index, accessory in pairs(player:GetDescendants()) do
		if accessory:IsA("Accessory") then
			accessory:AddTag("Accessory")
			if accessory.Name == "Top" then -- still a work-in-progress
				accessory:AddTag("Bad Accessory")
			end
		end
	end
end)
