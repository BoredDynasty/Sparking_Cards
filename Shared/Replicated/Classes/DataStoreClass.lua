---@diagnostic disable-next-line: duplicate-doc-class
--[=[
	@class DataStoreClass
-]=]
local DataStoreClass = {}
DataStoreClass.__index = DataStoreClass

-- // Datastores

local DataStoreService = game:GetService("DataStoreService")
local CardsData = DataStoreService:GetDataStore("Cards")
local RankData = DataStoreService:GetDataStore("Rank")
local ExperiencePoints = DataStoreService:GetDataStore("ExperiencePoints")
local PDS = DataStoreService:GetDataStore("PositionDataStore")
local PlayerRelated = DataStoreService:GetDataStore("PlayerRelated")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local Timer = require(ReplicatedStorage.Modules.Timer)

local SavedPositionGUI = ReplicatedStorage.Assets:FindFirstChild("ScreenGui")

local DataSavedRE = ReplicatedStorage.RemoteEvents.DataSaved

-- Function to check if the player is eligible for a daily reward
local function getDailyRewards(lastLogin)
	local currentDate = os.date("*t") -- Get current date table
	local lastDate = os.date("*t", lastLogin) -- Convert last login timestamp to date table

	-- Check if the last login was on a different day
	return currentDate.year ~= lastDate.year or currentDate.yday ~= lastDate.yday
end

--[[
Multipliers
1. Untitled
2. Chaos Indefinite
3. Chaotic Coloring
4. Absolute Sparking
--]]

--[[
Abilities
1. Charge
2. Ultimate
3. Fusion Coil
4. Supernatural Radiation
]]

--[=[
	Starts up the Data System when a new player joins.

	@function PlayerAdded
		@within DataStoreClass
		@param player Player
--]=]
function DataStoreClass.PlayerAdded(player: Player) -- Setup DataSystem
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = player
	leaderstats.Name = "leaderstats"
	--

	local success, data = nil, nil

	local Cards = Instance.new("IntValue")
	Cards.Name = "Cards"
	Cards.Parent = leaderstats
	success, data = pcall(function()
		return CardsData:GetAsync(`player:{player.UserId}`)
	end)
	data = data :: {}
	if not success or data == nil then
		data = { BaseValue = 10 }
		warn(`Could not get data for {player.Name}`)
	elseif success or data then
		pcall(function()
			CardsData:SetAsync(`player:{player.UserId}`, data)
		end)
	end

	Cards.Value = data.BaseValue
	--
	local Rank = Instance.new("StringValue")
	Rank.Name = "Rank"
	Rank.Parent = leaderstats
	Rank.Value = RankData:GetAsync(`player:{player.UserId}`) or GlobalSettings.StartingRankValue
	RankData:SetAsync(player.UserId, Rank.Value)

	local EXP = Instance.new("IntValue")
	EXP.Name = "ExperiencePoints"
	EXP.Parent = leaderstats
	EXP.Value = ExperiencePoints:GetAsync(`player:{player.UserId}`) or GlobalSettings.StartingExperienceValue
	ExperiencePoints:SetAsync(`player:{player.UserId}`, EXP.Value)

	local Character = game.Workspace:WaitForChild(player.Name)
	local GetPosition = nil

	pcall(function()
		GetPosition = PDS:GetAsync(`player:{player.UserId}`)
	end)

	if GetPosition and SavedPositionGUI then
		task.spawn(function()
			local SavedPosition = SavedPositionGUI:Clone()
			SavedPosition.Parent = player.PlayerGui
			SavedPosition.LastPosition.Visible = true

			SavedPosition.LastPosition.Yes.MouseButton1Down:Once(function()
				SavedPosition.Enabled = false
				Character:MoveTo(Vector3.new(GetPosition[1][1], GetPosition[1][2], GetPosition[1][3]))
				Character.HumanoidRootPart.Orientation =
					Vector3.new(GetPosition[2][1], GetPosition[2][2], GetPosition[2][3])
				print(`Set Position of {player.DisplayName}`)
			end)

			SavedPosition.LastPosition.No.MouseButton1Down:Once(function()
				SavedPosition.Enabled = false
				return
			end)
		end)
	end

	success, data = pcall(function()
		return PlayerRelated:GetAsync(`player:{player.UserId}`)
	end)

	if not success or data == nil then
		-- Init because theres no data
		data = { Cards = 0, lastLogin = 0 }
	end

	if getDailyRewards(data.lastLogin) then
		-- Reset the daily streak
		data.Cards = data.Cards + 5
		player.leaderstats.Cards.Value = player.leaderstats.Cards.Value + data.Cards
		CardsData:SetAsync(`player:{player.UserId}`, player.leaderstats.Cards.Value)
		print(`Player has been awarded {data.Cards} Cards for logging in today!`)
		data.lastLogin = os.time() -- Update last login time to now
	end

	-- Save updated data
	pcall(function()
		PlayerRelated:SetAsync(`player:{player.UserId}`, {
			Cards = data.Cards,
			lastLogin = data.lastLogin,
		})
	end)

	DataSavedRE:FireClient(player, `You have been awarded {data.Cards} Cards for logging in today!`)
	local timePlayedKey = "time-played-store"
	local timePlayed_Data = PlayerRelated:GetAsync(timePlayedKey)
	if not timePlayed_Data then
		task.spawn(function()
			local timer = Timer.new()
			timer:Start()
			PlayerRelated:SetAsync(timePlayedKey, {
				player,
				timer.elapsedTime,
			})
			while true do
				task.wait(1)
				PlayerRelated:SetAsync(timePlayedKey, {
					player,
					timer.elapsedTime,
				})
			end
			player.AncestryChanged:Once(function() -- as if the player left
				timer:Stop() -- Stop the timer when the player leaves
				-- or else itll cause lag
			end)
		end)
	end

	return leaderstats
end

local function saveData(player, send: boolean)
	task.spawn(function()
		if send == true then
			DataSavedRE:FireClient(player)
		end
		pcall(function()
			CardsData:SetAsync(`player:{player.UserId}`, player.leaderstats.Cards.Value)
			RankData:SetAsync(`player:{player.UserId}`, player.leaderstats.Rank.Value)
			ExperiencePoints:SetAsync(`player:{player.UserId}`, player.leaderstats.ExperiencePoints.Value)
		end)
		return "Saved!"
	end)
end

--[=[
	@function SaveData
		@within DataStoreClass
		@param player Player
--]=]
function DataStoreClass.SaveData(player: Player)
	saveData(player, true)
end

function DataStoreClass.PlayerRemoving(player: Player)
	saveData(player, false)
end

--[=[
	@function SavePostion
		@param player Player
--]=]
function DataStoreClass.SavePosition(player) -- Saves Player Position
	pcall(function()
		local character = player.Character or game.Workspace:WaitForChild(player.Name)
		local HumanoidPos: CFrame | Vector3 = character.HumanoidRootPart.Position
		local HumanoidOri: CFrame | Vector3 = character.HumanoidRootPart.Orientation

		PDS:SetAsync(player.UserId, {
			{ math.floor(HumanoidPos.X), math.floor(HumanoidPos.Y), math.floor(HumanoidPos.Z) },
			{ math.floor(HumanoidOri.X), math.floor(HumanoidOri.Y), math.floor(HumanoidOri.Z) },
		})
		print(
			"Saved "
				.. player.DisplayName
				.. "'s Position: ("
				.. math.floor(HumanoidPos.X)
				.. " , "
				.. math.floor(HumanoidPos.Y)
				.. " , "
				.. math.floor(HumanoidPos.Z)
				.. " ) "
		)
	end)
end

local function saveAllData() -- Saves All Data
	for _, player: Player in pairs(Players:GetPlayers()) do
		pcall(function()
			local HumanoidPos: CFrame? = game.Workspace:WaitForChild(player.Name).HumanoidRootPart.Position
			local HumanoidOri: CFrame? = game.Workspace:WaitForChild(player.Name).HumanoidRootPart.Orientation

			PDS:SetAsync(player.UserId, {
				{
					math.floor(HumanoidPos.X),
					math.ceil(HumanoidPos.Y),
					math.floor(HumanoidPos.Z),
				},
				{
					math.floor(HumanoidOri.X),
					math.floor(HumanoidOri.Y),
					math.floor(HumanoidOri.Z),
				},
			})
			print(
				"Saved "
					.. player.DisplayName
					.. "'s Position: ("
					.. math.floor(HumanoidPos.X)
					.. " , "
					.. math.floor(HumanoidPos.Y)
					.. " , "
					.. math.floor(HumanoidPos.Z)
					.. " ) "
			)
		end)
	end

	pcall(function()
		DataSavedRE:FireAllClients("all")
		for _, player: Player in pairs(Players:GetChildren()) do
			saveData(player, false)
		end
	end)
end

--[=[
	@function SetAsync
		@within DataStoreClass
		@param DatastoreName string
		@param player Player
		@param value any
@return boolean, string
--]=]
function DataStoreClass:SetAsync(DatastoreName: string, player: Player, value: any) -- CASE SENSITIVE
	local UnknownDataStore = DataStoreService:GetDataStore(DatastoreName)
	local GotDataStore = false
	local result

	if UnknownDataStore ~= nil then
		result = "Success"
		UnknownDataStore:SetAsync(player.UserId, value)
		GotDataStore = true
	else
		result = "Failed"
	end

	return GotDataStore, result
end

function DataStoreClass:GetDataStore(datastore, scope: string?): DataStore
	return DataStoreService:GetDataStore(datastore, scope)
end

function DataStoreClass:GetAsync(datastore, key)
	return datastore:GetAsync(key)
end

--[=[
	@function getPlayerStats
		@within DataStoreClass
		@return Folder?
--]=]
function DataStoreClass:getPlayerStats(): IntValue
	return Players.LocalPlayer:WaitForChild("leaderstats").Cards
end

--[=[
	@function StartBindToClose
		@within DataStoreClass
		@param custom any
--]=]
function DataStoreClass.StartBindToClose(custom) -- If the game is being shutdown, it saves all player data. This cannot work in the Studio.
	if not RunService:IsStudio() then
		if not custom then
			game:BindToClose(saveAllData)
		else
			custom()
			game:BindToClose(saveAllData)
		end
	else
		print("Game is in Studio Mode.")
	end
end

return DataStoreClass
