--!strict
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MessagingService = game:GetService("MessagingService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)
local MathClass = require(ReplicatedStorage.Classes.MathClass)
local PostClass = require(ReplicatedStorage.Classes.PostClass)

local player = Players.LocalPlayer
local Character = player.Character
local Humanoid = Character.Humanoid

-- PlayerHud
local PlayerHud = script.Parent.Parent.Parent.PlayerHud

local playerProfileImage, _ =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
task.wait(9)
PlayerHud.Player.PlayerImage.Image = playerProfileImage
PlayerHud.Player:FindFirstChildOfClass("TextLabel").Text = player.DisplayName

UserInputService.WindowFocusReleased:Connect(function()
	TweenService:Create(PlayerHud.Player.Design.Radial, TweenInfo.new(1), { ImageColor3 = Color3.fromHex("#ff5353") })
		:Play()
end)

UserInputService.WindowFocused:Connect(function()
	TweenService:Create(PlayerHud.Player.Design.Radial, TweenInfo.new(1), { ImageColor3 = Color3.fromHex("#55ff7f") })
		:Play()
end)
