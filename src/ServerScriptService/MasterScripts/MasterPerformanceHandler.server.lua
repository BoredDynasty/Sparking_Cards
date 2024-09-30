--!strict
-- This script is also a command script!
local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local AnalyticsClass = require(ReplicatedStorage.Classes.AnalyticsClass)
local UserInputType = require(ReplicatedStorage.Classes.UserInputType)
local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)
local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

Players.PlayerAdded:Connect(function(player)
	player.CharacterRemoving:Connect(function(character)
		task.defer(character.Destroy, character)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	task.defer(player.Destroy, player)
end)

-- extra

for index, textLabels in pairs(game:GetDescendants()) do -- imagine doing getdescedants on the game
	if textLabels:IsA("TextLabel") then
		textLabels.FontFace = Font.fromName("Builder Extended" or "BuilderSans")
	end
end

GlobalSettings.GrabPrivateServer()

local calculatedFPS
local startTime = os.clock()
local X = 0.01
local FPS_Counter = 0

local function getServerUptime() -- Returns the Server Uptime
	local lastServerStart = Stats.Server.StartTime
	local currentTime = tick()
	local serverUptime = currentTime - lastServerStart

	return serverUptime
end

local function GetBenchmarks() -- Returns Benchmarks, also sends thru a webhook
	FPS_Counter += 1
	if (os.clock() - startTime) >= X then
		local fps = math.floor(FPS_Counter / (os.clock() - startTime))
		calculatedFPS = fps
		FPS_Counter = 0
		startTime = os.clock()
		PostClass.PostAsync("New Benchmarks", "From Studio, here are the benchmarks. Frames ~" .. tostring(fps))
		AnalyticsClass.LogCustomEvent(nil, "Avg. FPS: " .. calculatedFPS)
	end
	for index, instances in pairs(workspace:GetDescendants()) do
		PostClass.PostAsync(
			"New Benchmarks",
			"From Studio, here are the benchmarks. Instances From Memory or Index ~" .. index or Stats.InstanceCount,
			tostring(table.concat({ instances }, ", ")) -- gulp
		)
		PostClass.PostAsync(
			"New Benchmarks",
			"From Studio, here are the benchmarks. Total Memory Usage ~" .. Stats:GetTotalMemoryUsageMb(),
			" | In Megabytes | From A " .. UserInputType.getInputType() .. " Device"
		)
	end
	PostClass.PostAsync(
		"New Benchmarks",
		"Game Version | " .. game.PlaceVersion,
		"Running | " .. _VERSION .. " | duh that should be obvious"
	)
	return FPS_Counter
end

-- ContextActionService:BindAction("FPS", GetFPS, true, Enum.KeyCode.Eight, Enum.KeyCode.ButtonStart)

if RunService:IsStudio() then
	local str = "STUDIO MODE \nPress The Zero Key To Post Benchmarks"
	print(string.format(str, "%q"))
	local BenchmarksRemote = Instance.new("UnreliableRemoteEvent", ReplicatedStorage)
	BenchmarksRemote.Name = "Benchmarks"
	BenchmarksRemote.OnServerEvent:Connect(function(player)
		GetBenchmarks()
	end)
else
	print("The game is not in Studio mode, benchmarks here are disabled.")
end

local Clone = ReplicatedStorage.Assets.Server:Clone()
Clone.Parent = workspace

local SteppedConnection

task.spawn(function()
	SteppedConnection = RunService.Stepped:Connect(function(time, deltaTime)
		Clone.Top.BillboardGui.ServerTime.Text = "Server Uptime; " .. tostring(getServerUptime)
			or game.Workspace.DistributedGameTime
		Clone.Top.BillboardGui.FPS.Text = "Client FPS; " .. tostring(GetBenchmarks)
	end)
end)

task.spawn(function()
	for index, object in pairs(game:GetDescendants()) do
		if object:IsA("GuiButton") then
			object:AddTag("gui_button")
			print("found " .. index .. " gui_buttons")
		end
	end
end)

DataStoreClass.StartBindToClose(GetBenchmarks)
