--!nocheck

---@class Class
local Class = {}

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)
local RewardsClass = require(ReplicatedStorage.Classes.RewardsClass)
local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local MainTag = "Cards"
local Tag = CollectionService:GetTagged(MainTag)

---@tag Starts Listening to Instances that have the tag 'Cards'
function Class:StartListening() --  starts listening
	for index, tagged in pairs(Tag) do
		if index < 1 then
			return
		end

		local Tagged = tagged
		local HumanoidRootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local leaderstats = Players.LocalPlayer:WaitForChild("leaderstats")
		Tagged.Touched:Once(function(otherPart)
			if otherPart.Parent:FindFirstChild("HumanoidRootPart") then
				local player = Players:GetPlayerFromCharacter(otherPart.Parent)
				if not player then
					return
				end
				DataStoreClass.SaveData(player)

				local AwardedCards = Tagged:GetAttribute("Amount")

				if not AwardedCards then
					AwardedCards = GlobalSettings.DefaultAward
				end

				RewardsClass.NewReward(player, AwardedCards, nil, nil, AwardedCards)
			end
			local newT = Tagged:Clone()
			Tagged:Destroy()
			task.wait(25)
			newT.Parent = Tagged.Position
		end)
	end
end
return Class
