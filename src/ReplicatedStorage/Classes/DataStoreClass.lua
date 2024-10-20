--!nocheck
---@diagnostic disable-next-line: duplicate-doc-class
---@class DataStore
local DataStore = {}
---@__index DataStore
DataStore.__index = DataStore

local DataStoreService = game:GetService("DataStoreService")
local CardsData = DataStoreService:GetDataStore("Cards")
local RankData = DataStoreService:GetDataStore("Rank")
local MultiplierType = DataStoreService:GetDataStore("Card Type")
local Abilities = DataStoreService:GetDataStore("StoredAbilities")
local ExperiencePoints = DataStoreService:GetDataStore("ExperiencePoints")
local PDS = DataStoreService:GetDataStore("PositionDataStore")
local HostServerData = DataStoreService:GetDataStore("HostServerData")

local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local NetworkServer = game:GetService("NetworkServer")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)
local LevelManager = require(ReplicatedStorage.Modules.LevelManager)
local RewardsClass = require(ReplicatedStorage.Classes.RewardsClass)

local SavedPositionGUI = ReplicatedStorage.Assets:WaitForChild("ScreenGui")
local Actions = {
	y = SavedPositionGUI.LastPosition.Yes,
	n = SavedPositionGUI.LastPosition.No,
}
print("We save your data every 30 Seconds. Thought you may want to know.")

local tweenservice = game.TweenService
local TInfoParams = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

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

local BillBoardGui = ReplicatedStorage.Assets:WaitForChild("BillboardGui")

--[=[
	Starts up the Data System when a new player joins.

	@function PlayerAdded
		@within DataStore
		@param player Player
--]=]
function DataStore.PlayerAdded(player: Player) -- Setup DataSystem
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local Cards = Instance.new("IntValue")
	Cards.Name = "Cards" --Cash Value
	Cards.Parent = leaderstats
	Cards.Value = CardsData:GetAsync(player.UserId) or GlobalSettings.StartingCardsValue
	CardsData:SetAsync(player.UserId, Cards.Value)

	local Rank = Instance.new("StringValue")
	Rank.Name = "Rank"
	Rank.Parent = leaderstats
	Rank.Value = RankData:GetAsync(player.UserId) or GlobalSettings.StartingRankValue
	RankData:SetAsync(player.UserId, Rank.Value)

	local Multiplier = Instance.new("StringValue")
	Multiplier.Name = "MultiplierType"
	Multiplier.Parent = leaderstats
	Multiplier.Value = MultiplierType:GetAsync(player.UserId) or GlobalSettings.StartingMultiplierValue
	MultiplierType:SetAsync(player.UserId, Multiplier.Value)

	local AbiltiesFolder = Instance.new("Folder")
	AbiltiesFolder.Parent = player
	local Ability = Instance.new("StringValue")
	Ability.Name = "MainAbility"
	Ability.Parent = AbiltiesFolder
	Ability.Value = "None"
	Ability.Value = Abilities:GetAsync(player.UserId) or GlobalSettings.StartingAbilityValue
	Abilities:SetAsync(player.UserId, Ability.Value)

	local EXP = Instance.new("IntValue")
	EXP.Name = "ExperiencePoints"
	EXP.Parent = leaderstats
	EXP.Value = ExperiencePoints:GetAsync(player.UserId) or GlobalSettings.StartingExperienceValue
	ExperiencePoints:SetAsync(player.UserId, EXP.Value)

	local experience = LevelManager.new(Rank.Value)
	if experience.Name ~= Rank.Value then
		RewardsClass.NewReward(player, experience.Reward)
	end

	local Character = game.Workspace:WaitForChild(player.Name)
	local GetPosition

	pcall(function()
		GetPosition = PDS:GetAsync(player.UserId)
	end)

	if player.PlayerGui.MainHud.CanvasGroup.GroupTransparency == 1 then -- teehee
		if GetPosition then
			local SavedPosition = SavedPositionGUI:Clone()
			SavedPosition.Parent = player.PlayerGui
			SavedPosition.LastPosition.Visible = true

			SavedPosition.LastPosition.Yes.MouseButton1Down:Connect(function()
				SavedPosition.Enabled = false
				Character:MoveTo(Vector3.new(GetPosition[1][1], GetPosition[1][2], GetPosition[1][3]))
				Character.HumanoidRootPart.Orientation =
					Vector3.new(GetPosition[2][1], GetPosition[2][2], GetPosition[2][3])
				print("Set Position of " .. Character.Name)
			end)

			SavedPosition.LastPosition.No.MouseButton1Down:Connect(function()
				SavedPosition.Enabled = false
			end)
		end
	end

	return experience
end

local function saveData(player)
	pcall(function()
		CardsData:SetAsync(player.UserId, player.leaderstats.Cards.Value)
		RankData:SetAsync(player.UserId, player.leaderstats.Rank.Value)
		MultiplierType:SetAsync(player.UserId, player.leaderstats.MultiplierType.Value)
		Abilities:SetAsync(player.UserId, player.leaderstats.MainAbility.Value)
		ExperiencePoints:SetAsync(player.UserId, player.leaderstats.ExperiencePoints.Value)
	end)
	return "Saved!"
end

--[=[
	@function SaveData
		@within DataStore
		@param player Player
--]=]
function DataStore.SaveData(player: Player)
	saveData(player)
end

function DataStore.PlayerRemoving(player: Player)
	saveData(player)
end

--[=[
	@function SavePostion
		@param player Player
--]=]
function DataStore.SavePosition(player) -- Saves Player Position
	pcall(function()
		local HumanoidPos = game.Workspace:WaitForChild(player.Name).HumanoidRootPart.Position
		local HumanoidOri = game.Workspace:WaitForChild(player.Name).HumanoidRootPart.Orientation

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
	for i, v in pairs(Players:GetChildren()) do
		pcall(function()
			local HumanoidPos = game.Workspace:WaitForChild(v.Name).HumanoidRootPart.Position
			local HumanoidOri = game.Workspace:WaitForChild(v.Name).HumanoidRootPart.Orientation

			PDS:SetAsync(v.UserId, {
				{
					math.floor(HumanoidPos.X),
					math.floor(HumanoidPos.Y),
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
					.. v.DisplayName
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
		for _, player in pairs(Players:GetChildren()) do
			saveData(player)
		end
	end)
end

--[=[
	@function SetAsync
		@within DataStore
		@param DatastoreName string
		@param player Player
		@param value any
@return boolean, string
--]=]
function DataStore:SetAsync(DatastoreName: string, player: Player, value: any) -- CASE SENSITIVE
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

function DataStore:GetAsync(datastore, scope: string?): DataStore
	return DataStoreService:GetDataStore(datastore, scope)
end

--[=[
	@function getPlayerStats
		@within DataStore
		@return Folder?
--]=]
function DataStore:getPlayerStats() -- Returns a players "leaderstats" folder
	return Players.LocalPlayer:WaitForChild("leaderstats")
end

--[=[
	@function BindSaveButton
		@within DataStore
--]=]
function DataStore.BindSaveButton() -- Listens whenever a player presses a certain button or key, then saves all thier data
	ContextActionService:BindAction("Save", saveAllData, true, Enum.KeyCode.Escape, Enum.KeyCode.ButtonR3)
end

--[=[
	@function StartBindToClose
		@within DataStore
		@param custom any
--]=]
function DataStore.StartBindToClose(custom) -- If the game is being shutdown, it saves all player data. This cannot work in the Studio.
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

--[=[
	@function CreateStat
		@within DataStore
		@param player Player
		@param stat any
		@param initialValue any
		@return DataStore?, any?
--]=]
function DataStore:CreateStat(player: Player, stat: any, initialValue)
	local data = DataStoreService:GetAsync(stat, player.UserId)
	local any = Instance.new("StringValue", player:WaitForChild("leaderstats"))

	any.Value = initialValue
	data:SetAsync(player.UserId, any.Value)

	return data, any
end

return DataStore
