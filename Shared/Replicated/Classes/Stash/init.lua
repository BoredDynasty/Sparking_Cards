--!nonstrict

-- Stash.lua

--[=[
	@class Stash
-]=]
local Stash = {}
Stash.__index = Stash

local DataStoreService = game:GetService("DataStoreService")
-- local CardsData = DataStoreService:GetDataStore("Cards")
-- local RankData = DataStoreService:GetDataStore("Rank")
-- local MultiplierType = DataStoreService:GetDataStore("MultiplierType")
-- local ExperiencePoints = DataStoreService:GetDataStore("ExperiencePoints")
-- local PDS = DataStoreService:GetDataStore("PositionDataStore")

local Calculator = require(script.Calculator)

-- IMPORTANT --
--[=[
	Make sure your Stash keys are named uniquely.
	For example: Stash:SetAsync(`{player.UserId}-Money`)
	And, add names to your Stash' For example: Stash:SetAsync(key, {
		["Name"] = "Money",
		["Value"] = 10
		["Default"] = 0
		["Other"] = {}
	})
--]=]

function Stash.new()
	local self = setmetatable({}, Stash)
	self.Stashes = {}
	self.Calculator = Calculator
	return self
end

function Stash:newStash(name: string, scope): DataStore
	return pcall(function()
		local newStash = DataStoreService:GetDataStore(name, scope)
		table.insert(self.Stashes, newStash)
		return newStash
	end)
end

function Stash:getStash(stash: DataStore, key): any
	return pcall(function()
		stash:GetAsync(key)
	end)
end

function Stash:setStash(stash: DataStore, key, value: any)
	return pcall(function()
		stash:SetAsync(key, value)
		stash:GetAsync(key)
	end)
end

--[=[
	Starts up the Data System when a new player joins.

	@function PlayerAdded
		@within Stash
		@param player Player
--]=]
function Stash:PlayerAdded(player: Player, keys: { [string]: string })
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = player
	leaderstats.Name = "leaderstats"

	for name, stash: DataStore in self.Stashes do
		local stashInst = Instance.new("StringValue")
		stashInst.Parent = leaderstats
		stashInst.Name = name
		for key_name, key in keys do
			if key_name == name then
				local var = stash:GetAsync(key)
				stashInst.Value = var.BaseValue -- Remember to add this! --
			end
		end
	end
	return leaderstats
end

--[=[
	@function SaveData
		@within Stash
		@param player Player
--]=]
function Stash:SaveData(key, value)
	pcall(function()
		for _, stash: DataStore in self.Stashes do
			stash:SetAsync(key, value)
		end
	end)
end

return Stash
