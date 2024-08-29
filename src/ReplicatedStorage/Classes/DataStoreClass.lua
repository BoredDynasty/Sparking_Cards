--!strict
local Class = {}

local DataStore = game:GetService("DataStoreService")
local CardsData = DataStore:GetDataStore("Cards")
local RankData = DataStore:GetDataStore("Rank")
local MultiplierType = DataStore:GetDataStore("Card Type")

local PDS = DataStore:GetDataStore("PositionDataStore")

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local MathClass = require(ReplicatedStorage.Classes.MathClass)

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

local StartingCardsValue = 5
local StartingRankValue = "Bronze I"
local StartingMultiplierValue = "Untitled"

--[[
Multipliers
1. Untitled
2. Chaos Indefinite
3. Chaotic Coloring
4. Absolute Sparking
--]]

local BillBoardGui = ReplicatedStorage.Assets:WaitForChild("BillboardGui")

function Class.PlayerAdded(player: Player) -- Setup DataSystem
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local Cards = Instance.new("IntValue")
	Cards.Name = "Cards" --Cash Value
	Cards.Parent = leaderstats
	-- Cards.Value = 5 -- Starter Value
	Cards.Value = CardsData:GetAsync(player.UserId) or StartingCardsValue
	CardsData:SetAsync(player.UserId, Cards.Value)

	local Rank = Instance.new("StringValue")
	Rank.Name = "Rank"
	Rank.Parent = leaderstats
	-- Rank.Value = "Bronze I"
	Rank.Value = RankData:GetAsync(player.UserId) or StartingRankValue
	RankData:SetAsync(player.UserId, Rank.Value)

	local Multiplier = Instance.new("StringValue")
	Multiplier.Name = "MultiplierType"
	Multiplier.Parent = leaderstats

	Multiplier.Value = MultiplierType:GetAsync(player.UserId) or StartingMultiplierValue
	MultiplierType:SetAsync(player.UserId, Multiplier.Value)

	--if Multiplier.Value == "Absolute Sparking" then
	--local Aura = AuraTypes.AbsoluteSparking:Clone()
	--for i, v in pairs(Aura:GetDescendants()) do
	--v.Parent = player.Character:FindFirstChild("Torso")
	--end
	--end

	local Character = game.Workspace:WaitForChild(player.Name)
	local GetPosition

	local succes, err = pcall(function()
		GetPosition = PDS:GetAsync(player.UserId)
	end)

	if not succes then
		PostClass.PostAsync("Couldnt Save Player Data | ", err, player.Name, 7419530)
	else
		print("got pos")
	end

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
	end)
end

function Class.SaveData(player: Player) -- Manually Save Data
	local success, err = pcall(function()
		CardsData:SetAsync(player.UserId, player.leaderstats.Cards.Value)
		RankData:SetAsync(player.UserId, player.leaderstats.Rank.Value)
		MultiplierType:SetAsync(player.UserId, player.leaderstats.MultiplierType.Value)
	end)

	if not success then
		PostClass.PostAsync("Failed To Save Player Data | ", err, nil, 7419530)
	end
end

function Class.PlayerRemoving(player: Player)
	local success, err = pcall(function() -- Saving DataStores may fail sometimes. Best to wrap em' in a pcall.
		CardsData:SetAsync(player.UserId, player.leaderstats.Cards.Value)
		RankData:SetAsync(player.UserId, player.leaderstats.Rank.Value)
		MultiplierType:SetAsync(player.UserId, Players.leaderstats.MultiplierType.Value)
	end)
	if not success then
		PostClass.PostAsync("Failed To Save Player Data | ", err, nil, 7419530)
	end
end

function Class.SavePosition(player: Player) -- Saves Player Position
	for i, v in pairs(Players:GetChildren()) do
		local success, err = pcall(function()
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
		if not success then
			PostClass.PostAsync("Failed To Save Player Postion | ", err, nil, 7419530)
		end
	end
end

local function saveAllData() -- Saves All Data
	for i, v in pairs(Players:GetChildren()) do
		local success, err = pcall(function()
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
					.. MathClass.RoundDown(HumanoidPos.X)
					.. " , "
					.. MathClass.RoundDown(HumanoidPos.Y)
					.. " , "
					.. MathClass.RoundDown(HumanoidPos.Z)
					.. " ) "
			)
		end)
		if not success then
			PostClass.PostAsync(
				"Data Failiure ",
				"A Data Failure Has Happened. Here are the Users Involved. | " .. table.concat(v),
				" | Last Positions = { "
					.. v.DisplayName
					.. "Positions = "
					.. v.Character.HumanoidRootPart.Position.X
					.. v.Character.HumanoidRootPart.Position.Y
					.. v.Character.HumanoidRootPart.Position.Z
			)
		end
	end

	local success, err = pcall(function()
		for i, v in pairs(Players:GetChildren()) do
			CardsData:SetAsync(v.UserId, v.leaderstats.Cards.Value)
			RankData:SetAsync(v.UserId, v.leaderstats.Rank.Value)
			MultiplierType:SetAsync(v.UserId, v.leaderstats.MultiplierType.Value)
		end
	end)
	if not success then
		PostClass.PostAsync(
			"Failed To Save Player Data | ",
			err,
			" This is most likely because the game was bounded to close. The players were most likely automatically deleted. ",
			7419530
		)
	end
end

function Class.StartBindToClose() -- If the game is being shutdown, it saves all player data. This cannot work in the Studio.
	if not RunService:IsStudio() then
		game:BindToClose(saveAllData)
	else
		print("Game is in Studio Mode.")
	end
end

return Class