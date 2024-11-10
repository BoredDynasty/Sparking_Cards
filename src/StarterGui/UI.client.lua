--!nocheck

print(script.Name)

-- // Services

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")

-- // Requires

local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffect)
local SoundManager = require(ReplicatedStorage.Modules.SoundManager)

-- // Variables

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = player:GetMouse()
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

-- Fast Travel
local FastTravelRE = ReplicatedStorage.RemoteEvents.FastTravel

local FastTravelGui = player.PlayerGui.PlaceSwitch

local travelAreas = {
	["Main"] = game.JobId,
	["Exploring"] = 18213010529,
}

local function fastTravel(part: BasePart)
	local from: string? = part:GetAttribute("From")
	TweenService:Create(FastTravelGui.CanvasGroup, TweenInfo.new(0.5), { GroupTransparency = 0 }):Play()
	local searchText = FastTravelGui.CanvasGroup.Frame.Search.Text
	local dismissTime = 5
	local str =
		[[Are you sure you want to go to <font color="#55ff7f">Exploring Area?</font>?<br></br><font color="#335fff">Click here to fast travel.</font><br></br> Dismissing in [ time ]...]]
	task.spawn(function()
		repeat
			task.wait(1)
			local dismissString = string.gsub(str, "[ time ]", dismissTime)
		until dismissTime == 0
		if dismissTime == 0 then
			return
		end
	end)
	if FastTravelGui.CanvasGroup.GroupTransparency == 0 then
		UIEffectsClass.Sound("PowerUp")
		Mouse.Button1Down:Once(function()
			UIEffectsClass.Sound("Favorite")
			FastTravelRE:FireServer(from, travelAreas, FastTravelGui)
		end)
	end
end

for _, travelPart: BasePart in CollectionService:GetTagged("LeavePlace") do
	travelPart.TouchEnded:Connect(function(otherPart)
		if otherPart then
			fastTravel(otherPart)
		end
	end)
end

-- Music

local MusicGui = player.PlayerGui.Music
local NowPlaying = MusicGui.CanvasGroup.NowPlaying

local currentlyPlaying: string?

local function playlist(directory: Instance?)
	for i, sound: Sound in directory:GetDescendants() do
		local alreadyPlayed = {}
		table.insert(alreadyPlayed, sound, i)
		sound.Volume = 0.2
		sound.Looped = false
		sound:Play()
		task.wait(sound.TimeLength)
		local new = next(directory:GetDescendants(), sound)
		currentlyPlaying = sound or new
		if table.find(alreadyPlayed, sound) then
			print("Replaying playlist | " .. directory.Name)
		end
	end
	print("Task performed")
	return currentlyPlaying
end

NowPlaying.MouseEnter:Wait()
local pauseTime = 5
NowPlaying.Text = [[Keep hovering to <font color="#ff4e41"Pause>/font>.]]
repeat
	task.wait(1)
	pauseTime = pauseTime - 1
	print("Waiting until pause")
	if NowPlaying.MouseLeave then
		print("Cancelled action.")
		task.synchronize()
		return
	end
until pauseTime == 0
NowPlaying.Text = "Paused [ musicName ]"
local gsub = string.gsub(NowPlaying.Text, "[ musicName ]", currentlyPlaying)
NowPlaying.Text = "Paused " .. gsub
print("Task performed. Very sigma")
