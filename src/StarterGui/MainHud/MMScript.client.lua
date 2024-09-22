--!strict

local blur = game.Lighting:FindFirstChildOfClass("BlurEffect")
local settingsFrame = script.Parent.Settings
local mainFrame = script.Parent.Frame
local emptyFrame = script.Parent.EmptyFrame

local ContentProvider = game:GetService("ContentProvider")

local GameLoaded = game:GetService("ReplicatedStorage").RemoteEvents.GameLoaded

mainFrame.Visible = true

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotificationService = game:GetService("ExperienceNotificationService")

-- Controller Support
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local HapticsService = game:GetService("HapticService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

local tweenservice = game.TweenService
local TInfoParams = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

blur.Enabled = true

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera

local Settings = GlobalSettings.PlayerSettings
local hidePlayers = false

local function PlayGame()
	task.wait(0.1)
	mainFrame.Visible = false
	tweenservice:Create(blur, TweenInfo.new(1), { Size = 0 }):Play()
	Camera.CameraType = Enum.CameraType.Custom

	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 2.5)
	task.wait(0.2)
	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
end

local function OpenSettings()
	settingsFrame.Rotation = 90 -- just to set up the visuals
	settingsFrame.Size = UDim2.new(0, 0, 0, 0)
	game.ReplicatedStorage.Sounds.FrameOpen:Play()

	task.wait(0.1)
	settingsFrame.Visible = true
	tweenservice:Create(settingsFrame, TInfoParams, { Rotation = -5 }):Play()
	tweenservice:Create(settingsFrame, TInfoParams, { Size = UDim2.new(0.31, 0, 0.409, 0) }):Play()

	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.5)
	task.wait(0.2)
	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
end

local function ExitSettings()
	tweenservice:Create(settingsFrame, TInfoParams, { Rotation = 90 }):Play()
	tweenservice:Create(settingsFrame, TInfoParams, { Size = UDim2.new(0, 0, 0, 0) }):Play()
	game.ReplicatedStorage.Sounds.FrameClose:Play()
	task.wait(0.23)
	settingsFrame.Visible = false

	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.5)
	task.wait(0.2)
	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
end

mainFrame.PlayButton.MouseButton1Down:Connect(function()
	PlayGame()
end)

mainFrame.Settings.MouseButton1Down:Connect(function()
	OpenSettings()
	settingsFrame.TextBox:CaptureFocus()
end)

settingsFrame.Exit.MouseButton1Down:Connect(function()
	ExitSettings()
	settingsFrame.TextBox:ReleaseFocus()
end)

local function checkSettings()
	if settingsFrame.TextBox.Text == Settings.A then
		game.Lighting.ClockTime = 12
		game.Lighting.ExposureCompensation = 0
		game.Lighting.Brightness = 5
		game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		game.Lighting.ColorShift_Top = Color3.fromRGB(85, 170, 255)
		game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		game.Lighting.EnvironmentDiffuseScale = 1
		game.Lighting.EnvironmentSpecularScale = 1
		game.Lighting.ShadowSoftness = 0.2
	elseif settingsFrame.TextBox.Text == Settings.B then
		game.Lighting.ClockTime = 4
		game.Lighting.ExposureCompensation = -3
		game.Lighting.Brightness = -5
		game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		game.Lighting.ColorShift_Top = Color3.fromRGB(85, 170, 255)
		game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		game.Lighting.EnvironmentDiffuseScale = 1
		game.Lighting.EnvironmentSpecularScale = 1
		game.Lighting.ShadowSoftness = 0.2
	end
end

task.spawn(checkSettings)

if settingsFrame.TextBox.Text == Settings.C then
	hidePlayers = true
	task.wait(0.05)
	task.spawn(function()
		while task.wait(0.5) do
			if hidePlayers then
				for index, player in pairs(game.Players:GetPlayers()) do
					for index, playerModel in pairs(workspace:GetChildren()) do
						if player.Name == playerModel.Name then
							if player.Name ~= game.Players.LocalPlayer.Name then
								playerModel.Parent = ReplicatedStorage
							end
						end
					end
				end
			else
				for index, player in pairs(game.Players:GetPlayers()) do
					for index, playerModel in pairs(workspace:GetChildren()) do
						if player.Name == playerModel.Name then
							if player.Name ~= game.Players.LocalPlayer.Name then
								playerModel.Parent = game.Workspace
							end
						end
					end
				end
			end
		end
	end)
else
	hidePlayers = false
end

if settingsFrame.TextBox.Text == Settings.E then
	task.spawn(function()
		for index, lightBeams in pairs(game.Workspace:GetDescendants()) do
			if lightBeams:IsA("Beam") then
				if lightBeams.Name == "Beam" then
					lightBeams.Enabled = false
				end
			end
		end
	end)
else
	task.spawn(function()
		for index, lightBeams in pairs(game.Workspace:GetDescendants()) do
			if lightBeams:IsA("Beam") then
				if lightBeams.Name == "Beam" then
					lightBeams.Enabled = true
				end
			end
		end
	end)
end
