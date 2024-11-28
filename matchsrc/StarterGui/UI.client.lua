--!nocheck

print(script.Name .. " script is running. 0")

-- // Services

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")

-- // Requires

local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffect)

-- // Variables

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = player:GetMouse()
local Camera = game.Workspace.CurrentCamera
local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)

local function showGui(canvas: CanvasGroup)
	local tween = TweenService:Create(canvas, TInfo, { GroupTransparency = 0 }):Play()
	return tween
end

local function hideGui(canvas: CanvasGroup)
	local tween = TweenService:Create(canvas, TInfo, { GroupTransparency = 1 }):Play()
	return tween
end

-- // Everything else

-- Main Menu
local MainMenu = player.PlayerGui.MainHud
local MainMenuFrame = MainMenu.CanvasGroup.Frame
MainMenu.CanvasGroup.GroupTransparency = 0
MainMenu.CanvasGroup.Frame.Visible = true
repeat
	task.wait()
	Camera.CameraType = Enum.CameraType.Scriptable
until Camera.CameraType == Enum.CameraType.Scriptable
-- -1604.172, 267.097, 6215.333, 24.286, 65.438, 0
Camera.CFrame = CFrame.new(-1604.172, 267.097, 6215.333) -- The roads

MainMenuFrame.PlayButton.MouseButton1Click:Once(function()
	Camera.CameraType = Enum.CameraType.Custom
	hideGui(MainMenu.CanvasGroup)
end)

-- PlayerHud
local PlayerHud = player.PlayerGui.PlayerHud
local playerProfileImage =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local DialogRemote = ReplicatedStorage.RemoteEvents.NewDialogue

local function newDialog(dialog)
	UIEffectsClass.TypeWriterEffect(dialog, PlayerHud.Player.TextLabel)
	UIEffectsClass.changeColor("Blue", PlayerHud.Player.Design.Radial)
	task.wait(10)
	UIEffectsClass.changeColor("Green", PlayerHud.Player.Design.Radial)
end

UserInputService.WindowFocusReleased:Connect(function()
	UIEffectsClass.changeColor("Red", PlayerHud.Player.Design.Radial)
	UIEffectsClass:Zoom(true)
	UIEffectsClass:BlurEffect(true)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
	local dialog_str = player.DisplayName .. ": Hey, you *may* want to come back to the game!"
	dialog_str = UIEffectsClass:markdownToRichText(dialog_str) :: string
	newDialog(dialog_str)
end)

UserInputService.WindowFocused:Connect(function()
	UIEffectsClass.changeColor("Green", PlayerHud.Player.Design.Radial)
	UIEffectsClass:Zoom(false)
	UIEffectsClass:BlurEffect(true)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
	local dialog_str = "System: Hey, thanks for coming back!"
	newDialog()
end)

DialogRemote.OnClientEvent:Connect(newDialog)

-- Gamepasses

local BuyCards = player.PlayerGui.DynamicUI.BuyCards

local function promptPurchase(ID)
	MarketPlaceService:PromptProductPurchase(player, ID)
end

BuyCards.Frame.Buy.MouseButton1Down:Connect(function()
	promptPurchase(1904591683) -- Buying Cards
end)
print(script.Name .. " script is running. 1")
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

	Frame.PlayButton.MouseButton1Down:Once(function()
		hideGui(Canvas)
	end)
end

mainHud()
print(script.Name .. " script is running. 2")

-- Fast Travel
local FastTravel = player.PlayerGui.PlaceSwitch
local TravelRE = ReplicatedStorage.RemoteEvents.FastTravel

local function potentialTravel(place: string, placeID: string)
	showGui(FastTravel.CanvasGroup)
	local frame = FastTravel.CanvasGroup.Frame
	local str = [[
	Are you sure you want to go to <font color="#55ff7f">[ place ]</font>?<br></br><font color="#335fff">Click here to fast travel.</font><br></br> Dismissing in [ time ]...
	]]
	str = string.gsub(str, "[ place ]", place)
	local dismissTime = 5
	local confirmed = false
	repeat
		task.wait(1)
		dismissTime = dismissTime - 1
		str = string.gsub(str, "[ time ]", tostring(dismissTime))
	until dismissTime == 0
	if dismissTime == 0 then
		confirmed = false
		return
	end
	frame.Hitbox.MouseButton1Click:Once(function()
		if confirmed == false then
			return
		else
			-- We'll invoke the server saying the player has accepted.
			TravelRE:InvokeServer(confirmed, place, placeID)
			dismissTime = -1
		end
	end)
end

TravelRE.OnClientInvoke(potentialTravel)
print(script.Name .. " script is running. 4")
