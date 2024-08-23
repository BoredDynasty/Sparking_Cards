--!strict
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local HTTPClass = require(ReplicatedStorage.Classes.PostClass)

local webhook =
	"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"
local HTTP = game:GetService("HttpService")

-- For Peformant Reasons

Players.PlayerRemoving:Connect(function(player)
	player:Destroy()
	player.Character:Destroy()

	if player.Destroying and player.Character.Destroying then
		HTTPClass.PostAsync("Performance", "Successfully Disconnected All Functions from the player to the character.")
	else
	end
end)

local calculatedFPS
local startTime = os.clock()
local X = 0.01
local FPS_Counter = 0

local function GetBenchmarks() -- ehehehehe~!
	FPS_Counter += 1
	if (os.clock() - startTime) >= X then
		local fps = math.floor(FPS_Counter / (os.clock() - startTime))
		calculatedFPS = fps
		FPS_Counter = 0
		startTime = os.clock()
		HTTPClass.PostAsync(
			"New Benchmarks",
			"From Studio, here are the benchmarks. Frames ~" .. tostring(calculatedFPS)
		)
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
