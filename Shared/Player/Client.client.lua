--!nonstrict

-- Client.client.lua

print(script.Name)

-- // Services -- //

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketPlaceService = game:GetService("MarketplaceService")

-- // Variables -- //

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local Humanoid = character:WaitForChild("Humanoid")
local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)

---------------------------------- Camera --------------------------------

local ReplicateRE = ReplicatedStorage.RemoteEvents.ReplicateCutscene
local Camera = game.Workspace.CurrentCamera

local defaultCFrame = Camera.CFrame

-- Cutscenes

local replicateConnection = nil
local connection: RBXScriptConnection = nil
replicateConnection = ReplicateRE.OnClientEvent:Connect(function(cutsceneFolder: Folder)
	if not connection then
		connection = RunService.RenderStepped:Connect(function(delta)
			local frames = (delta * 60)
			local steppedFrames: CFrameValue | IntValue =
				cutsceneFolder:FindFirstChild(tonumber(math.ceil(frames)))
			character.Humanoid.AutoRotate = false
			Camera.CameraType = Enum.CameraType.Scriptable
			if steppedFrames then
				Camera.CFrame = character.HumanoidRootPart.CFrame * steppedFrames.Value
			else
				connection:Disconnect()
				connection = nil
				character.Humanoid.AutoRotate = true
				Camera.CameraType = Enum.CameraType.Custom
				Camera.CFrame = defaultCFrame
			end
		end)
	end
end)

-- Sway

local function lerp(a, b, t)
	return a + (b - a) * t
end

local RenderPriority = Enum.RenderPriority.Camera.Value + 1
RunService:BindToRenderStep("Camera-Sway", RenderPriority + 1, function(delta)
	task.spawn(function()
		local mouseDelta = UserInputService:GetMouseDelta()
		local sway = 0
		sway = lerp(sway, math.clamp(mouseDelta.X, -5, 5), (5 * delta))
		-- print("swaying")
		if not replicateConnection then
			Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, math.rad(sway))
		end
	end)
end)

-- Head Bobbing

local function bobble(humanoid: Humanoid)
	if humanoid.MoveDirection.Magnitude > 0 then
		local time = tick()
		local x = math.cos(time * 5) * 0.25
		local y = math.abs(math.sin(time * 5)) * 0.25
		local offset = Vector3.new(x, y, 0)
		humanoid.CameraOffset = humanoid.CameraOffset:Lerp(offset, 0.25)
		-- print("bobbling")
	else
		humanoid.CameraOffset = humanoid.CameraOffset * 0.25
	end
end

RunService.PreRender:Connect(function()
	if character then
		local humanoid = character:WaitForChild("Humanoid")
		if humanoid then
			bobble(humanoid)
		end
	end
end)

-- Tilt

local function getRollAngle(humanoid)
	return defaultCFrame.RightVector:Dot(humanoid.MoveDirection)
end

local function roll(humanoid)
	local rollAngle = getRollAngle(humanoid)
	local rotate = CFrame.new():Lerp(CFrame.Angles(0, 0, math.rad(rollAngle)), 0.075)
	Camera.CFrame = Camera.CFrame * rotate
end

RunService:BindToRenderStep("Tilt", RenderPriority, function()
	-- print("tilting")
	if character then
		local humanoid = character:WaitForChild("Humanoid")
		if humanoid then
			roll(humanoid)
		end
	end
end)

print("Camera has finished executing.")

---------------------------------- UI --------------------------------

-- // Requires -- /

local UIEffect = require(ReplicatedStorage.Packages.UIEffect)
local CameraService = require(ReplicatedStorage.Modules.CameraService)

-- local Interactions = require(ReplicatedStorage.Modules.Interactions)

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

local function setCameraView(view)
	CameraService:SetCameraView(view)
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
task.spawn(function() -- so we don't yield the current thread
	repeat
		task.wait()
		Camera.CameraType = Enum.CameraType.Scriptable
	until Camera.CameraType == Enum.CameraType.Scriptable
end)

--- 1604.172, 267.097, 6215.333, 24.286, 65.438, 0 -- the roads
Camera.CFrame = CFrame.new(-1721.989, 270.293, 182.625) -- Baseplate

MainMenuFrame.PlayButton.MouseButton1Click:Once(function()
	task.spawn(function() -- so we don't yield the current thread
		repeat
			task.wait()
			Camera.CameraType = Enum.CameraType.Custom
		until Camera.CameraType == Enum.CameraType.Custom
	end)
	UIEffect:changeVisibility(MainMenu.CanvasGroup, false)
end)

-- PlayerHud
local PlayerHud = player.PlayerGui.PlayerHud
local OpenProfile = PlayerHud.Player.Design.Background -- im not sure why i labelled this as background
local Profile = PlayerHud.CanvasGroup.Frame
local playerProfileImage =
	Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local DialogRemote = ReplicatedStorage.RemoteEvents.NewDialogue

local LargeDialog = player.PlayerGui.Dialog.CanvasGroup.Frame

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
		UIEffect:changeVisibility(Profile.Parent, true)
		CameraService:ChangeFOV(60, false)
		-- UIEffect:BlurEffect(true)
		reloadProfileImg(playerProfileImage)
	elseif Profile.Visible == true then
		UIEffect.changeColor("Green", OpenProfile)
		UIEffect:changeVisibility(Profile.Parent, false)
		CameraService:ChangeFOV(70, false)
		-- UIEffect:BlurEffect(false)
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
	-- UIEffect.changeColor(newBackgroundColor, NewBattle) this wouldn't work
	TweenService:Create(NewBattle, TInfo, { BackgroundColor3 = Color3.fromHex("#000000") }):Play()
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
		playingAnimation = Humanoid:LoadAnimation(animation)
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

local function setCameraHost(otherPart)
	if type(otherPart) == "string" then
		CameraService:SetCameraView(otherPart) -- "otherPart" is a string
	else
		CameraService:SetCameraHost(otherPart)
	end
end

local function windowReleased()
	UIEffect.changeColor("Red", PlayerHud.Player.Design.Radial)
	CameraService:ChangeFOV(70, false)
	-- UIEffect:BlurEffect(true)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
end

local function windowFocused()
	UIEffect.changeColor("Green", PlayerHud.Player.Design.Radial)
	CameraService:ChangeFOV(60, false)
	-- UIEffect:BlurEffect(false)
	PlayerHud.Player.PlayerImage.Image = playerProfileImage
	PlayerHud.Player.TextLabel.Text = player.DisplayName
end

UserInputService.WindowFocusReleased:Connect(windowReleased)
UserInputService.WindowFocused:Connect(windowFocused)
ReplicatedStorage.RemoteEvents.SetCameraHost.OnClientEvent:Connect(setCameraHost)
ReplicatedStorage.RemoteEvents.SetCameraView.OnClientEvent:Connect(setCameraView)

-- Tooltip Triggers
PlayerHud.Player.MouseEnter:Connect(function()
	showTooltip(`That's you! <font size="8">this also doesn't work</font>`, player.DisplayName)
end)
PlayerHud.Player.MouseLeave:Connect(hideTooltip)

NewBattle.MouseEnter:Connect(function()
	showTooltip("This probably doesn't work yet.", "Battle")
end)
NewBattle.MouseLeave:Connect(hideTooltip)

print(`UI has finished executing.`)
