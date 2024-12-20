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
local MultiplierType = DataStoreService:GetDataStore("MultiplierType")
local ExperiencePoints = DataStoreService:GetDataStore("ExperiencePoints")
local PDS = DataStoreService:GetDataStore("PositionDataStore")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local SavedPositionGUI = ReplicatedStorage.Assets:FindFirstChild("ScreenGui")

local DataSavedRE = ReplicatedStorage.RemoteEvents.DataSaved

local function calculate(inst: IntValue | Instance)
	local total: number = 0
	local fire: number = tonumber(inst:GetAttribute("Fire"))
	local frost: number = tonumber(inst:GetAttribute("Frost"))
	local plasma: number = tonumber(inst:GetAttribute("Plasma"))
	local water: number = tonumber(inst:GetAttribute("Water"))

	if fire and frost and plasma and water then
		total = fire + frost + plasma + water
	else
		warn(`The following attributes are missing: {fire}(fire), {frost}(frost), {plasma}(plasma), {water}(water).`)
	end
	inst:SetAttribute("Total", total)
	return total
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
	local Cards = Instance.new("IntValue")
	Cards.Name = "Cards"
	Cards.Parent = leaderstats
	CardsData:SetAsync(player.UserId, {
		["BaseValue"] = calculate(Cards) or 4,
		["Types"] = {
			["Fire"] = Cards:GetAttribute("Fire") or 1,
			["Frost"] = Cards:GetAttribute("Frost") or 1,
			["Plasma"] = Cards:GetAttribute("Plasma") or 1,
			["Water"] = Cards:GetAttribute("Water") or 1,
		},
		["Abilities"] = {
			["Charge"] = {
				["Healing"] = 10,
				["Unlocked"] = false,
			},
			["Ultimate"] = {
				["Damage"] = 95,
				["Healing"] = false,
				["Unlocked"] = false,
			},
			["Fusion Coil"] = {
				["Damage"] = 1005,
				["Healing"] = false,
				["Unlocked"] = false,
			},
			["Supernatural Radiation"] = {
				["Damage"] = math.huge,
				["Healing"] = false,
				["Unlocked"] = false,
			},
		},
	})
	local _GetAsync = CardsData:GetAsync(player.UserId)
	Cards.Value = _GetAsync.BaseValue
	Cards:SetAttribute("Fire", _GetAsync.Types.Fire)
	Cards:SetAttribute("Frost", _GetAsync.Types.Frost)
	Cards:SetAttribute("Plasma", _GetAsync.Types.Plasma)
	Cards:SetAttribute("Water", _GetAsync.Types.Water)
	--
	local Rank = Instance.new("StringValue")
	Rank.Name = "Rank"
	Rank.Parent = leaderstats
	Rank.Value = RankData:GetAsync(player.UserId) or GlobalSettings.StartingRankValue
	RankData:SetAsync(player.UserId, Rank.Value)
	--
	local Multiplier = Instance.new("StringValue")
	Multiplier.Name = "MultiplierType"
	Multiplier.Parent = leaderstats
	Multiplier.Value = MultiplierType:GetAsync(player.UserId) or GlobalSettings.StartingMultiplierValue
	MultiplierType:SetAsync(player.UserId, Multiplier.Value)

	local EXP = Instance.new("IntValue")
	EXP.Name = "ExperiencePoints"
	EXP.Parent = leaderstats
	EXP.Value = ExperiencePoints:GetAsync(player.UserId) or GlobalSettings.StartingExperienceValue
	ExperiencePoints:SetAsync(player.UserId, EXP.Value)

	local Character = game.Workspace:WaitForChild(player.Name)
	local GetPosition

	pcall(function()
		GetPosition = PDS:GetAsync(player.UserId)
	end)

	if GetPosition and SavedPositionGUI then
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
			return
		end)
	end

	return leaderstats, { CardsData, RankData, ExperiencePoints }
end

local function saveData(player, send: boolean)
	task.spawn(function()
		if send == true then
			DataSavedRE:FireClient(player)
		end
		pcall(function()
			CardsData:SetAsync(player.UserId, player.leaderstats.Cards.Value)
			RankData:SetAsync(player.UserId, player.leaderstats.Rank.Value)
			MultiplierType:SetAsync(player.UserId, player.leaderstats.MultiplierType.Value)
			ExperiencePoints:SetAsync(player.UserId, player.leaderstats.ExperiencePoints.Value)
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
	@function BindSaveButton
		@within DataStoreClass
--]=]
function DataStoreClass.BindSaveButton() -- Listens whenever a player presses a certain button or key, then saves all thier data
	ContextActionService:BindAction("Save", saveAllData, true, Enum.KeyCode.Escape, Enum.KeyCode.ButtonR3)
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

--[=[
	@function CreateStat
		@within DataStoreClass
		@param player Player
		@param stat any
		@param initialValue any
		@return DataStore?, any?
--]=]
function DataStoreClass:CreateStat(player: Player, stat: any, initialValue)
	local data = DataStoreService:GetAsync(stat, player.UserId)
	local any = Instance.new("StringValue")
	any.Parent = player:FindFirstChild("leaderstats")

	any.Value = initialValue
	data:SetAsync(player.UserId, any.Value)

	return data, any
end

return DataStoreClass
