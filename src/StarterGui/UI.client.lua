--!nocheck

print(script.Name)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")

local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)
local Camera = require(ReplicatedStorage.Modules.Camera)
local SoundManager = require(ReplicatedStorage.Modules.SoundManager)

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = player:GetMouse()

-- PlayerHud
local PlayerHud = player.PlayerGui.PlayerHud
local playerProfileImage =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local DialogRemote = ReplicatedStorage.RemoteEvents.NewDialogue

task.spawn(function()
	while true do
		task.wait(25)
		PlayerHud.Player.PlayerImage.Image = playerProfileImage
		PlayerHud.Player.TextLabel.Text = player.DisplayName
	end
end)

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

local function newDialog(dialog)
	UIEffectsClass.TypeWriterEffect(dialog, PlayerHud.Player.TextLabel)
	UIEffectsClass.changeColor("Blue", PlayerHud.Player.Design.Radial)
	task.wait(10)
	UIEffectsClass.changeColor("Green", PlayerHud.Player.Design.Radial)
end

DialogRemote.OnClientEvent:Connect(newDialog)

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
		local anim = "rbxassetid://" .. tostring(AnimationID)
		local oldnim = Character:FindFirstChild("LocalAnimation")
		Humanoid.WalkSpeed = 0

		if playingAnimation ~= nil then
			playingAnimation:Stop()
		end

		if oldnim ~= nil then
			if oldnim.AnimationId == anim then
				oldnim:Destroy()
				Humanoid.WalkSpeed = 14

				return
			end
			oldnim:Destroy()
		end

		local animation = Instance.new("Animation", Character)
		animation.Name = "LocalAnimation"
		animation.AnimationId = anim
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

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
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

-- Main Menu
local function mainHud()
	local MainHudGui = player.PlayerGui.MainHud
	local Canvas = MainHudGui.CanvasGroup
	local Frame = Canvas:FindFirstChild("Frame")
	UIEffectsClass.Sound("MainMenu")

	Canvas.GroupTransparency = 0

	local function continueGameplay()
		UIEffectsClass:changeVisibility(Canvas, false, Frame)
		UIEffectsClass.Sound("MainMenu", true)
	end
	local function queueMatch()
		local p = { player }
		ReplicatedStorage.RemoteEvents.JoinQueueEvent:InvokeServer(p)
		Frame.Match:FindFirstChild("TextLabel").Text = "Finding"
		Frame.Match:FindFirstChild("TextLabel").Interactable = false
	end
	Frame.PlayButton.MouseButton1Down:Connect(continueGameplay)
	Frame.Match.MouseButton1Down:Connect(queueMatch)
end

mainHud()
