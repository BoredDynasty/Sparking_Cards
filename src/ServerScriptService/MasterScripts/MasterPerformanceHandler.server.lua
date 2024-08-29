--!strict
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local HTTPClass = require(ReplicatedStorage.Classes.PostClass)
local AnalyticsClass = require(ReplicatedStorage.Classes.AnalyticsClass)

local HTTP = game:GetService("HttpService")

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
		HTTPClass.PostAsync("New Benchmarks", "From Studio, here are the benchmarks. Frames ~" .. tostring(FPS_Counter))
		AnalyticsClass.LogCustomEvent(nil, "Avg. FPS: " .. calculatedFPS)
		return calculatedFPS
	end
end

-- ContextActionService:BindAction("FPS", GetFPS, true, Enum.KeyCode.Eight, Enum.KeyCode.ButtonStart)

if RunService:IsStudio() then
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
		end
		if input.KeyCode == Enum.KeyCode.Zero then
			GetBenchmarks()
		end
	end)
else
	print("The game is not in Studio mode, benchmarks here are disabled.")
end

local Clone = ServerStorage.Assets.Server:Clone()
Clone.Parent = workspace

local SteppedConnection

task.spawn(function()
	SteppedConnection = RunService.Stepped:Connect(function(time, deltaTime)
		Clone.Top.BillboardGui.ServerTime.Text = "Server Uptime; " .. tostring(getServerUptime)
			or game.Workspace.DistributedGameTime
		Clone.Top.BillboardGui.FPS.Text = "Client FPS; " .. tostring(GetBenchmarks)
	end)
end)

game:BindToClose(GetBenchmarks)
