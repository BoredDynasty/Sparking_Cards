--!nocheck
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local MathClass = require(ReplicatedStorage:WaitForChild("Classes").MathClass) -- Use waitforchild cuz everythings still loading
local GlobalSettings = require(ReplicatedStorage.GlobalSettings) -- hopefully this would've loaded ehehehe~!
local UIEffectsClass = require(ReplicatedStorage.Classes:WaitForChild("UIEffectsClass"))

local TweenParams = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local loadingScreen = script.Loading

local clone = loadingScreen:Clone()
clone.Parent = Players.LocalPlayer.PlayerGui

local background = clone.Background

local indicator = background.Loading.dropshadow_16_20
local textIndicator = background.Loading

local GameSize = script.Parent:WaitForChild("ApproxGameSize").Value -- we will use this to determine the size of the game
GameSize = MathClass.RoundUp(GameSize * 0.5)

local function onGameLoaded()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures, true)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.SelfView, true)

	UIEffectsClass.changeColor("Green", indicator)
	clone.Background.Loading.Text = "Loaded."
	task.wait(1.5)
	TweenService:Create(background, TweenParams, { Position = UDim2.new(0, 0, 2, 0) }):Play()
	task.wait(2.3)
	clone:Destroy()
end

UserInputService.WindowFocusReleased:Connect(function()
	UIEffectsClass.changeColor("Red", indicator)
end)

UserInputService.WindowFocused:Connect(function()
	UIEffectsClass.changeColor("Yellow", indicator)
end)

if GlobalSettings.IsStudio == false then
	game.Loaded:Connect(function()
		UIEffectsClass.changeColor("Yellow", indicator)
		onGameLoaded()
	end)
else
	clone:Destroy()
end
