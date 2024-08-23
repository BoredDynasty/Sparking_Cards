--!strict

-- Finds tag within the game and when the part with the tag is touched, a remote fires.

-- // Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Analytics = game:GetService("AnalyticsService")
local CollectionService = game:GetService("CollectionService")

-- // Variables

local Remote = ReplicatedStorage.RemoteEvents.AwardPlayer

local MainTag = CollectionService:GetTagged("Awardable")

for _, Awardable in pairs(MainTag) do
	local AwardablePart = Awardable

	AwardablePart.Touched:Connect(function(hit)
		local Player = game.Players:GetPlayerFromCharacter(hit.Parent)
		if Player then
			Remote:FireClient(Player, 3)
		end
	end)
end
