--!nocheck

print(script.Name)

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = player:GetMouse()

-- PlayerHud
local PlayerHud = player.PlayerGui.PlayerHud
local playerProfileImage =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

PlayerHud.Player.PlayerImage.Image = playerProfileImage
PlayerHud.Player:FindFirstChildOfClass("TextLabel").Text = player.DisplayName

UserInputService.WindowFocusReleased:Connect(function()
	UIEffectsClass.changeColor("Red", PlayerHud.Player.Design.Radial)
	UIEffectsClass:Zoom(true)
	UIEffectsClass:BlurEffect(true)
end)

UserInputService.WindowFocused:Connect(function()
	UIEffectsClass.changeColor("Green", PlayerHud.Player.Design.Radial)
	UIEffectsClass:Zoom(false)
	UIEffectsClass:BlurEffect(true)
end)

-- Gamepasses

local BuyCards = player.PlayerGui.DynamicUI.BuyCards

local function promptPurchase(ID)
	MarketPlaceService:PromptProductPurchase(player, ID)
end

BuyCards.Frame.Buy.MouseButton1Down:Connect(function()
	promptPurchase(1904591683) -- Buying Cards
end)

-- Emotes

local EmoteGui = player.PlayerGui.EmoteGUI

local playingAnimation = nil

local function playanim(AnimationID)
	if Character ~= nil and Humanoid ~= nil then
		local AnimationID = "rbxassetid://" .. tostring(AnimationID)
		local oldanim = Character:FindFirstChild("LocalAnimation")
		Humanoid.WalkSpeed = 0

		if playingAnimation ~= nil then
			playingAnimation:Stop()
		end

		if oldanim ~= nil then
			if oldanim.AnimationId == AnimationID then
				oldanim:Destroy()
				Humanoid.WalkSpeed = 14

				return
			end
			oldanim:Destroy()
		end

		local animation = Instance.new("Animation", Character)
		animation.Name = "LocalAnimation"
		animation.AnimationId = AnimationID
		playingAnimation = Humanoid:LoadAnimation(animation)
		playingAnimation:Play()
		Humanoid.WalkSpeed = 0
	end
end

local HolderFrame = EmoteGui.HolderFrame

for _, emoteButtons in HolderFrame.Circle:GetDescendants() do
	if emoteButtons:IsA("GuiButton") then
		emoteButtons.MouseButton1Down:Connect(function()
			playanim(emoteButtons:FindFirstChildOfClass("IntValue").Value)
		end)
	end
end

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if input == Enum.KeyCode.Tab then
		if HolderFrame.Visible == true then
			HolderFrame.Visible = false
		else
			HolderFrame.Visible = true
		end
	end
end)
