--!nocheck

print(script.Name)

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")

-- // Requires

local UIEffectsClass = require(ReplicatedStorage.Modules.UIEffect)

-- // Variables

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local Humanoid = character:WaitForChild("Humanoid")
local Camera = game.Workspace.CurrentCamera
local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)

-- // Everything else

-- Main Menu
local MainMenu = player.PlayerGui.MainHud
local MainMenuFrame = MainMenu.CanvasGroup.Frame
MainMenu.CanvasGroup.GroupTransparency = 0
repeat
	task.wait()
	Camera.CameraType = Enum.CameraType.Scriptable
until Camera.CameraType == Enum.CameraType.Scriptable

Camera.CFrame = CFrame.new(-1604.172, 267.097, 6215.333, 24.286, 65.438, 0) -- The roads

MainMenuFrame.PlayButton.MouseButton1Click:Once(function()
	Camera.CameraType = Enum.CameraType.Custom
	TweenService:Create(MainMenu.CanvasGroup, TInfo, { GroupTransparency = 1 }):Play()
end)

-- PlayerHud
local PlayerHud = player.PlayerGui.PlayerHud
local playerProfileImage =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local DialogRemote = ReplicatedStorage.RemoteEvents.NewDialogue

UserInputService.WindowFocusReleased:Connect(function()
	UIEffectsClass.changeColor("Red", PlayerHud.Player.Design.Radial)
	UIEffectsClass:Zoom(true)
	UIEffectsClass:BlurEffect(true)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
end)

UserInputService.WindowFocused:Connect(function()
	UIEffectsClass.changeColor("Green", PlayerHud.Player.Design.Radial)
	UIEffectsClass:Zoom(false)
	UIEffectsClass:BlurEffect(true)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
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
	if character ~= nil and Humanoid ~= nil then
		local anim = "rbxassetid://" .. tostring(AnimationID)
		local oldnim = character:FindFirstChild("LocalAnimation")
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

		local animation = Instance.new("Animation")
		animation.Parent = character
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
		HolderFrame.Visible = not HolderFrame.Visible
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
	Frame.PlayButton.MouseButton1Down:Connect(continueGameplay)
end

mainHud()

-- Tooltip
local tooltipFrame = player.PlayerGui.ToolTip.CanvasGroup.Frame

local function showTooltip(text, more)
	tooltipFrame.Details.Text = text -- Update the tooltip text
	tooltipFrame.Visible = true
	if more then
		if type(more) == "string" then
			tooltipFrame.Accept.Text = more
		else
			tooltipFrame.Accept.MouseButton1Click:Once(more)
		end
	end
end

local function hideTooltip()
	tooltipFrame.Visible = false
end

mouse.Move:Connect(function()
	if tooltipFrame.Visible then
		local xOffset, yOffset = 10, 10 -- Add some padding
		tooltipFrame.Position = UDim2.new(0, mouse.X + xOffset, 0, mouse.Y + yOffset)
	end
end)

-- Other

-- Tooltip Triggers
PlayerHud.Player.MouseEnter:Connect(function()
	showTooltip("That's you!", player.DisplayName)
end)

PlayerHud.Player.MouseLeave:Connect(function()
	hideTooltip()
end)
