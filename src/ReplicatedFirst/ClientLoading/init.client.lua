--!nonsrict

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local TweenParams = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local loadingScreen = script.Loading

local clone = loadingScreen:Clone()
clone.Parent = Players.LocalPlayer.PlayerGui

local background = clone.Background

local indicator = background.Loading.dropshadow_16_20
local textIndicator = background.Loading

local function onGameLoaded()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures, true)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.SelfView, true)

	clone.Background.Loading.Text = "Loaded."
	task.wait(1.5)
	TweenService:Create(background, TweenParams, { Position = UDim2.new(0, 0, 2, 0) }):Play()
	task.wait(2.3)
	clone:Destroy()
end

game.Loaded:Once(function()
	onGameLoaded()
end)
