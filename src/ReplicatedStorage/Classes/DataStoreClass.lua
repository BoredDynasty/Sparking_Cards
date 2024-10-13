--!nocheck
local Class = {}

local DataStore = game:GetService("DataStoreService")
local CardsData = DataStore:GetDataStore("Cards")
local RankData = DataStore:GetDataStore("Rank")
local MultiplierType = DataStore:GetDataStore("Card Type")
local Abilities = DataStore:GetDataStore("StoredAbilities")
local ExperiencePoints = DataStore:GetDataStore("ExperiencePoints")
local PDS = DataStore:GetDataStore("PositionDataStore")
local HostServerData = DataStore:GetDataStore("HostServerData")

local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local NetworkServer = game:GetService("NetworkServer")

local MathClass = require(ReplicatedStorage.Classes.MathClass)
local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local GiftRemote = ReplicatedStorage.RemoteEvents.GiftPlayer

local AuraTypes = {
	AbsoluteSparking = ReplicatedStorage.AuraTypes.AbsoluteSparking,
}

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

function Class.PlayerAdded(player: Player) -- Setup DataSystem
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local Cards = Instance.new("IntValue")
	Cards.Name = "Cards" --Cash Value
	Cards.Parent = leaderstats
	-- Cards.Value = 5 -- Starter Value
	Cards.Value = CardsData:GetAsync(player.UserId) or GlobalSettings.StartingCardsValue
	CardsData:SetAsync(player.UserId, Cards.Value)

	local Rank = Instance.new("StringValue")
	Rank.Name = "Rank"
	Rank.Parent = leaderstats
	-- Rank.Value = "Bronze I"
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

	--if Multiplier.Value == "Absolute Sparking" then
	--local Aura = AuraTypes.AbsoluteSparking:Clone()
	--for i, v in pairs(Aura:GetDescendants()) do
	--v.Parent = player.Character:FindFirstChild("Torso")
	--end
	--end

	local Character = game.Workspace:WaitForChild(player.Name)
	local GetPosition

	local succes = pcall(function()
		GetPosition = PDS:GetAsync(player.UserId)
	end)

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

	task.spawn(function()
		local Clone = BillBoardGui:Clone()
		Clone.Parent = player.Character:WaitForChild("Head")
		task.wait(1)
		Clone.Frame.Info.Text = player.DisplayName .. " / " .. tostring(Rank.Value)

		Rank.Changed:Connect(function(value: string)
			task.wait(1)
			RankData:SetAsync(player.UserId, value)
			Clone.Frame.Info.Text = player.DisplayName
				.. " / "
				.. tostring(value)
				.. " / "
				.. tostring(Multiplier.Value)
		end)

		Cards.Changed:Connect(function(value: number)
			task.wait(1)
			RankData:SetAsync(player.UserId, value)
		end)

		Multiplier.Changed:Connect(function(value: string)
			MultiplierType:SetAsync(player.UserId, value)
			Clone.Frame.Info.Text = player.DisplayName .. " / " .. tostring(Rank.Value) .. " / " .. tostring(value)
		end)

		Ability.Changed:Connect(function(value)
			Abilities:SetAsync(player.UserId, value)
		end)

		EXP.Changed:Connect(function(value)
			ExperiencePoints:SetAsync(player.UserId, value)
		end)
	end)
end

function Class.SaveData(player: Player) -- Manually Save Data
	local success = pcall(function()
		CardsData:SetAsync(player.UserId, player.leaderstats.Cards.Value)
		RankData:SetAsync(player.UserId, player.leaderstats.Rank.Value)
		MultiplierType:SetAsync(player.UserId, player.leaderstats.MultiplierType.Value)
		Abilities:SetAsync(player.UserId, player.leaderstats.MainAbility.Value)
		ExperiencePoints:SetAsync(player.UserId, player.leaderstats.ExperiencePoints.Value)
	end)
end

function Class.PlayerRemoving(player: Player)
	local success, err = pcall(function() -- Saving DataStores may fail sometimes. Best to wrap em' in a pcall.
		for index, values in pairs(player:WaitForChild("leaderstats"):GetDescendants()) do
			if values:IsA("StringValue") or values:IsA("IntValue") or values:IsA("NumberValue") then
				local store = values:GetAttribute("DataStore")
				local name = values:GetAttribute("DataName")
				store = loadstring(store) -- This should be a function.
				store()
			end
		end
	end)
end

function Class.SavePosition(player: Player) -- Saves Player Position
	for i, v in pairs(Players:GetChildren()) do
		local success = pcall(function()
			local HumanoidPos = game.Workspace:WaitForChild(v.Name).HumanoidRootPart.Position
			local HumanoidOri = game.Workspace:WaitForChild(v.Name).HumanoidRootPart.Orientation

			PDS:SetAsync(v.UserId, {
				{ math.floor(HumanoidPos.X), math.floor(HumanoidPos.Y), math.floor(HumanoidPos.Z) },
				{ math.floor(HumanoidOri.X), math.floor(HumanoidOri.Y), math.floor(HumanoidOri.Z) },
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
end

local function saveAllData() -- Saves All Data
	for i, v in pairs(Players:GetChildren()) do
		local success = pcall(function()
			local HumanoidPos = game.Workspace:WaitForChild(v.Name).HumanoidRootPart.Position
			local HumanoidOri = game.Workspace:WaitForChild(v.Name).HumanoidRootPart.Orientation

			PDS:SetAsync(v.UserId, {
				{
					MathClass.RoundDown(HumanoidPos.X),
					MathClass.RoundDown(HumanoidPos.Y),
					MathClass.RoundDown(HumanoidPos.Z),
				},
				{
					MathClass.RoundDown(HumanoidOri.X),
					MathClass.RoundDown(HumanoidOri.Y),
					MathClass.RoundDown(HumanoidOri.Z),
				},
			})
			print(
				"Saved "
					.. v.DisplayName
					.. "'s Position: ("
					.. MathClass.RoundDown(HumanoidPos.X)
					.. " , "
					.. MathClass.RoundDown(HumanoidPos.Y)
					.. " , "
					.. MathClass.RoundDown(HumanoidPos.Z)
					.. " ) "
			)
		end)
	end

	local success, err = pcall(function()
		for index, player in pairs(Players:GetChildren()) do
			CardsData:SetAsync(player.UserId, player.leaderstats.Cards.Value)
			RankData:SetAsync(player.UserId, player.leaderstats.Rank.Value)
			MultiplierType:SetAsync(player.UserId, player.leaderstats.MultiplierType.Value)
			Abilities:SetAsync(player.UserId, player.leaderstats.MainAbility.Value)
			ExperiencePoints:SetAsync(player.UserId, player.leaderstats.ExperiencePoints.Value)
		end
	end)
end

function Class.SetOutgoingKBPSLimit(limit)
	if not limit then
		limit = 90
	end

	NetworkServer:SetOutgoingKBPSLimit(limit)
	task.wait(300) -- i doubt the game will want such a limit
	NetworkServer:SetOutgoingKBPSLimit(math.huge)
end

function Class:SetAsync(DatastoreName: string, player: Player, value: any) -- CASE SENSITIVE
	local UnknownDataStore = DataStore:GetDataStore(DatastoreName)
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

function Class:GetAsync(datastore, scope: string?): DataStore
	return DataStore:GetDataStore(datastore, scope)
end

function Class:getPlayerStats() -- Returns a players "leaderstats" folder
	return Players.LocalPlayer:WaitForChild("leaderstats")
end

function Class.BindSaveButton() -- Listens whenever a player presses a certain button or key, then saves all thier data
	ContextActionService:BindAction("Save", saveAllData, true, Enum.KeyCode.Escape, Enum.KeyCode.ButtonR3)
end

function Class.StartBindToClose(custom) -- If the game is being shutdown, it saves all player data. This cannot work in the Studio.
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

function Class:CreateStat(player: Player, stat: any, initialValue)
	local data = Class:GetAsync(stat, player.UserId)
	local any = Instance.new("StringValue", player:WaitForChild("leaderstats"))

	any.Value = initialValue
	data:SetAsync(player.UserId, any.Value)
end

return Class
