--!strict
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")

local loadingScreen = script.Loading

local clone = loadingScreen:Clone()
clone.Parent = Players.LocalPlayer.PlayerGui

local background = clone.Background

local indicator = background.Loading.dropshadow_16_20
local textIndicator = background.Loading

local clone = loadingScreen:Clone()
clone.Parent = Players.LocalPlayer.PlayerGui

local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local GameSize = script.ApproxGameSize.Value -- we will use this to determine the size of the game
GameSize = math.ceil(GameSize * 0.5)

local function onGameLoaded()
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Captures, true)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.SelfView, true)

	TweenService:Create(indicator, TweenInfo.new(3), { ImageColor3 = Color3.fromHex("#ff4141") }):Play()
	clone.Background.Loading.Text = "Loaded."
	task.wait(1.5)
	TweenService:Create(background, TweenParams, { Position = UDim2.new(0, 0, 2, 0) }):Play()
	task.wait(2.3)
	clone:Destroy()
end

UserInputService.WindowFocusReleased:Connect(function()
	TweenService:Create(indicator, TweenInfo.new(1), { ImageColor3 = Color3.fromHex("#ff5353") }):Play()
end)

UserInputService.WindowFocused:Connect(function()
	TweenService:Create(indicator, TweenInfo.new(1), { ImageColor3 = Color3.fromHex("#ffff7f") }):Play()
end)

game.Loaded:Connect(function()
	indicator.ImageColor3 = Color3.fromHex("#ffff7f")
	task.wait(GameSize)
	onGameLoaded()
end)
