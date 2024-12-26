--!nonstrict

-- UI.client.lua

print(script.Name)

-- // Services -- //
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")

-- // Requires -- /
---@module Packages.UIEffect
local UIEffect = require(ReplicatedStorage.Modules.UIEffect)
local CameraService = require(ReplicatedStorage.Modules.CameraService)

-- local Interactions = require(ReplicatedStorage.Modules.Interactions)

-- // Variables -- //

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local Humanoid = character:WaitForChild("Humanoid")
local Camera = game.Workspace.CurrentCamera
local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)

-- // Remotes -- //
local DataSavedRE = ReplicatedStorage.RemoteEvents.DataSaved

-- // Functions -- //
local function handleAction(actionName, _, _, gui)
	if actionName == "Emote" then
		if gui.Visible == true then
			gui.Visible = false
		else
			gui.Visible = true
		end
	end
end

local function showTooltip(text, more)
	local tooltipFrame = player.PlayerGui.ToolTip.CanvasGroup.Frame
	tooltipFrame.Details.Text = text -- Update the tooltip text
	tooltipFrame.Visible = true
	tooltipFrame.Accept.Text = more
end

local function hideTooltip()
	local tooltipFrame = player.PlayerGui.ToolTip.CanvasGroup.Frame
	tooltipFrame.Visible = false
end

task.spawn(function()
	mouse.Move:Connect(function()
		local tooltipFrame: Frame = player.PlayerGui.ToolTip.CanvasGroup.Frame
		task.spawn(function()
			if tooltipFrame.Visible and not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
				-- local xOffset, yOffset = 0, 0 -- Add some padding
				local position: UDim2
				position = UDim2.new(0.5, 0, 0.5, 0)
				tooltipFrame.Position = position
				tooltipFrame.Position = position

				CameraService:ChangeFOV(70, false)
			-- local position = UDim2.new(0, mouse.X + xOffset, 0, mouse.Y + yOffset)
			else
				CameraService:ChangeFOV(60, false)
			end
		end)
	end)
end)

-- // Everything else -- //

-- Main Menu
local MainMenu = player.PlayerGui.MainHud
local MainMenuFrame = MainMenu.CanvasGroup.Frame
MainMenu.CanvasGroup.Visible = true
MainMenu.CanvasGroup.GroupTransparency = 0
MainMenuFrame.Visible = true
task.delay(0, function() -- so we don't yield the current thread
	repeat
		task.wait()
		Camera.CameraType = Enum.CameraType.Scriptable
	until Camera.CameraType == Enum.CameraType.Scriptable
end)

--- 1604.172, 267.097, 6215.333, 24.286, 65.438, 0 -- the roads
Camera.CFrame = CFrame.new(-1721.989, 270.293, 182.625) -- Baseplate

MainMenuFrame.PlayButton.MouseButton1Click:Once(function()
	Camera.CameraType = Enum.CameraType.Custom
	TweenService:Create(MainMenu.CanvasGroup, TInfo, { GroupTransparency = 1 }):Play()
end)

-- PlayerHud
local PlayerHud = player.PlayerGui.PlayerHud
local OpenProfile = PlayerHud.Player.Design.Background -- im not sure why i labelled this as background
local Profile = PlayerHud.CanvasGroup.Frame
local playerProfileImage =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local DialogRemote = ReplicatedStorage.RemoteEvents.NewDialogue

local LargeDialog = player.PlayerGui.Dialog.CanvasGroup.Frame

--[[ This part was causing problems somehow
UserInputService.WindowFocusReleased:Connect(function()
	UIEffect.changeColor("Red", PlayerHud.Player.Design.Radial)
	UIEffect:Zoom(true)
	-- UIEffect:BlurEffect(true)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
end)

UserInputService.WindowFocused:Connect(function()
	UIEffect.changeColor("Green", PlayerHud.Player.Design.Radial)
	UIEffect:Zoom(false)
	-- UIEffect:BlurEffect(false)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
end)
--]]

local function reloadProfileImg(img: string)
	task.spawn(function()
		PlayerHud.Player.PlayerImage.Image = img
		Profile.Frame.PlayerImage.Image = img
		print(`Reloaded: {player.DisplayName}'s profile image. {img}`) -- debug
	end)
end

local function newDialog(dialog: string)
	task.spawn(function()
		UIEffect.TypewriterEffect(dialog, LargeDialog.TextLabel)
		UIEffect.getModule("Curvy"):Curve(LargeDialog, TInfo, "Position", UDim2.new(0.5, 0, 0.944, 0))
		UIEffect.changeColor("Blue", PlayerHud.Player.Design.Radial)
		print(`New Dialog for {player.DisplayName}: {dialog}`)
		task.wait(10)
		UIEffect.changeColor("Green", PlayerHud.Player.Design.Radial)
		UIEffect.getModule("Curvy"):Curve(LargeDialog, TInfo, "Position", UDim2.new(0.5, 0, 1.5, 0))
		LargeDialog.TextLabel.Text = "" -- cleanup
	end)
end

local function dataSaved(message: string)
	task.spawn(function()
		if not message then
			local saveStatus = PlayerHud.Player.Check
			UIEffect.changeColor("#ccb6ff", PlayerHud.Player.Design.Radial)
			UIEffect.changeColor("#ccb6ff", saveStatus)
			UIEffect.getModule("Curvy"):Curve(PlayerHud.Player.PlayerImage, TInfo, "ImageTransparency", 1)
			UIEffect.getModule("Curvy"):Curve(saveStatus, TInfo, "ImageTransparency", 0)
			saveStatus.Visible = true
			UIEffect.TypewriterEffect("Saved!", PlayerHud.Player.TextLabel)
			task.wait(5)
			UIEffect.changeColor("Green", PlayerHud.Player.Design.Radial)
			UIEffect.changeColor("Green", saveStatus)
			UIEffect.getModule("Curvy"):Curve(PlayerHud.Player.PlayerImage, TInfo, "ImageTransparency", 0)
			UIEffect.getModule("Curvy"):Curve(saveStatus, TInfo, "ImageTransparency", 1)
			saveStatus.Visible = false
		elseif message then
			local saveStatus = PlayerHud.Player.Check
			UIEffect.changeColor("#ccb6ff", PlayerHud.Player.Design.Radial)
			UIEffect.changeColor("#ccb6ff", saveStatus)
			UIEffect.getModule("Curvy"):Curve(PlayerHud.Player.PlayerImage, TInfo, "ImageTransparency", 1)
			UIEffect.getModule("Curvy"):Curve(saveStatus, TInfo, "ImageTransparency", 0)
			saveStatus.Visible = true
			UIEffect.TypewriterEffect(message, PlayerHud.Player.TextLabel)
			task.wait(5)
			UIEffect.changeColor("Green", PlayerHud.Player.Design.Radial)
			UIEffect.changeColor("Green", saveStatus)
			UIEffect.getModule("Curvy"):Curve(PlayerHud.Player.PlayerImage, TInfo, "ImageTransparency", 0)
			UIEffect.getModule("Curvy"):Curve(saveStatus, TInfo, "ImageTransparency", 1)
			saveStatus.Visible = false
		end
	end)
end

local function openProfileGui()
	if Profile.Visible == false then
		UIEffect.changeColor("Blue", OpenProfile)
		UIEffect:changeVisibility(Profile, true)
		CameraService:ChangeFOV(70, false)
		UIEffect:BlurEffect(true)
		reloadProfileImg(playerProfileImage)
	elseif Profile.Visible == true then
		UIEffect.changeColor("Green", OpenProfile)
		UIEffect:changeVisibility(Profile, false)
		CameraService:ChangeFOV(60, false)
		UIEffect:BlurEffect(false)
		reloadProfileImg(playerProfileImage)
	end
end

OpenProfile.MouseButton1Click:Connect(openProfileGui)
DialogRemote.OnClientEvent:Connect(newDialog)
DataSavedRE.OnClientEvent:Connect(dataSaved)

print(`UI is executing.`)

-- Battle Gui
local BattleGui = player.PlayerGui.NewMatch.CanvasGroup
local NewBattle = BattleGui.Status.TextButton

local function newMatch()
	local EnterMatchRE: RemoteEvent = ReplicatedStorage.RemoteEvents.EnterMatch
	EnterMatchRE:FireServer()
	NewBattle.Text = "Finding Battle..."
	NewBattle.Interactable = false
	local newBackgroundColor = UIEffect.getModule("Color"):darker(NewBattle.BackgroundTransparency)
	-- UIEffect.changeColor(newBackgroundColor, NewBattle) this wouldn't work
	TweenService:Create(NewBattle, TInfo, { BackgroundTransparency = newBackgroundColor }):Play()
	print(`New Match for: {player.DisplayName}`)
end

NewBattle.MouseButton1Click:Connect(newMatch)

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

local function playAnim(AnimationID)
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
		local animator: Animator = character:FindFirstChild("Animator")
		playingAnimation = animator:LoadAnimation(animation)
		playingAnimation:Play()
		Humanoid.WalkSpeed = 0
	end
end

local HolderFrame = EmoteGui.HolderFrame

for _, emoteButtons: GuiButton in HolderFrame.Circle:GetChildren() do
	if emoteButtons:IsA("GuiButton") then
		emoteButtons.MouseButton1Down:Connect(function()
			playAnim(emoteButtons.AnimID.Value)
		end)
	end
end

EmoteGui.HolderFrame.Visible = false

ContextActionService:BindAction("Emote", function()
	handleAction("Emote", Enum.UserInputState.Begin, nil, EmoteGui.HolderFrame)
end, false, Enum.KeyCode.Tab)

print(`UI is halfway executing.`)

-- Main Menu
local function mainHud()
	local MainHudGui = player.PlayerGui.MainHud
	local Canvas = MainHudGui.CanvasGroup
	local Frame = Canvas:FindFirstChild("Frame")

	Canvas.GroupTransparency = 0

	local function continueGameplay()
		UIEffect:changeVisibility(Canvas, false)
		repeat
			task.wait()
			Camera.CameraType = Enum.CameraType.Custom
		until Camera.CameraType == Enum.CameraType.Custom
	end
	Frame.PlayButton.MouseButton1Down:Once(continueGameplay)
end

mainHud()

-- Info
local infoGui = player.PlayerGui.Info.CanvasGroup
local infoOpen = infoGui.Parent.FAB
local infoFrame = infoGui.Frame
infoOpen.MouseButton1Click:Connect(function()
	task.wait(1)
	if infoGui.Visible == false then
		UIEffect:changeVisibility(infoGui, true)
		CameraService:ChangeFOV(70, false)
	elseif infoGui.Visible == true then
		UIEffect:changeVisibility(infoGui, false)
		CameraService:ChangeFOV(60, false)
	end
end)
infoOpen.MouseEnter:Connect(function()
	showTooltip("Not Finished", "Blog")
end)
infoOpen.MouseLeave:Connect(hideTooltip)
infoFrame.Checkout.MouseButton1Click:Connect(function()
	UIEffect:changeVisibility(infoGui, false)
end)

print(`UI is almost done executing.`)

-- Other

local TipGui = player.PlayerGui.Tip

task.spawn(function()
	while true do
		-- print("spawn func is working")
		UIEffect.getModule("Curvy"):Curve(TipGui.Frame.TextLabel, TInfo, "TextTransparency", 1)
		task.wait(0.5)
		UIEffect.getModule("Curvy"):Curve(TipGui.Frame.TextLabel, TInfo, "TextTransparency", 0)
	end
end)

local function setCameraHost(otherPart)
	if type(otherPart) == "string" then
		CameraService:SetCameraView(otherPart) -- "otherPart" is a string
	else
		CameraService:SetCameraHost(otherPart)
	end
end

ReplicatedStorage.RemoteEvents.SetCameraHost.OnClientEvent:Connect(setCameraHost)

-- Tooltip Triggers
PlayerHud.Player.MouseEnter:Connect(function()
	showTooltip("That's you!", player.DisplayName)
end)
PlayerHud.Player.MouseLeave:Connect(hideTooltip)

TipGui.Frame.MouseEnter:Connect(function()
	showTooltip("Just tried to get this update out so it wouldn't be as boring.", "More to come!")
end)
TipGui.Frame.MouseLeave:Connect(hideTooltip)

print(`UI has finished executing.`)
