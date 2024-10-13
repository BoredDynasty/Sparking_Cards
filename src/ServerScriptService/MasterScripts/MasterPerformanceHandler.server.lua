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
	end

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

DataStoreClass.StartBindToClose(GetBenchmarks)
