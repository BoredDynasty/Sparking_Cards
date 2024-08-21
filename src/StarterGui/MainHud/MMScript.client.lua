--!strict

local blur = game.Lighting.Blur
local settingsFrame = script.Parent.Settings
local mainFrame = script.Parent.Frame
local creditsFrame = script.Parent.CreditsFrame
local emptyFrame = script.Parent.EmptyFrame

local ContentProvider = game:GetService("ContentProvider")

local GameLoaded = game:GetService("ReplicatedStorage").RemoteEvents.GameLoaded

mainFrame.Visible = true

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Controller Support
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local HapticsService = game:GetService("HapticService")


local tweenservice = game.TweenService
local TInfoParams = TweenInfo.new(0.3,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

blur.Enabled = true

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera

-- LoadingScreen.Visible = true

local Settings = {"Light Mode", "Dark Mode"}

local function creditsFrameSequence()
	tweenservice:Create(creditsFrame, TweenInfo.new(5), {BackgroundTransparency = 0})
	for i, v in pairs(creditsFrame:GetDescendants()) do
		if v:IsA("TextLabel") then
			tweenservice:Create(v, TweenInfo.new(5), {TextTransparency = 0})
		end
	end
	tweenservice:Create(creditsFrame.Image, TweenInfo.new(5), {ImageTransparency = 0})
end

local function stopCreditsSequence()
	tweenservice:Create(creditsFrame, TInfoParams, {BackgroundTransparency = 1})
	for i, v in pairs(creditsFrame:GetDescendants()) do
		if v:IsA("TextLabel") then
			tweenservice:Create(v, TInfoParams, {TextTransparency = 1})
		end
	end
	tweenservice:Create(creditsFrame.Image, TInfoParams, {ImageTransparency = 1})
	emptyFrame.Visible = true
	tweenservice:Create(emptyFrame, TweenInfo.new(2), {BackgroundTransparency = 0})
	task.wait(5)
	tweenservice:Create(emptyFrame, TweenInfo.new(2), {Position = UDim2.new(0, 0, -1, 0)})
	mainFrame.Visible = true
end

local function PlayGame()
	task.wait(0.1)
	mainFrame.Visible = false
	tweenservice:Create(blur, TweenInfo.new(1), {Size = 0}):Play()
	Camera.CameraType = Enum.CameraType.Custom	

	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 2.5)
	task.wait(0.2)
	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
end

local function OpenSettings()
	settingsFrame.Rotation = 90 -- just to set up the visuals
	settingsFrame.Size = UDim2.new(0, 0, 0, 0)
	game.ReplicatedStorage.Sounds.FrameOpen:Play()

	wait(0.1)
	settingsFrame.Visible = true
	tweenservice:Create(settingsFrame, TInfoParams, {Rotation = -5}):Play()
	tweenservice:Create(settingsFrame, TInfoParams, {Size = UDim2.new(0.31, 0, 0.409, 0)}):Play()

	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.5)
	task.wait(0.2)
	HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
end

local function ExitSettings()
	tweenservice:Create(settingsFrame, TInfoParams, {Rotation = 90}):Play()
	tweenservice:Create(settingsFrame, TInfoParams, {Size = UDim2.new(0, 0, 0, 0)}):Play()
	game.ReplicatedStorage.Sounds.FrameClose:Play()
	wait(0.23)
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


while true do
	wait(1)
	if settingsFrame.TextBox.Text == "Dark Mode" then 
		game.Lighting.ClockTime = 12
		game.Lighting.ExposureCompensation = 0
		game.Lighting.Brightness = 5
		game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		game.Lighting.ColorShift_Top = Color3.fromRGB(85, 170, 255)
		game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		game.Lighting.EnvironmentDiffuseScale = 1
		game.Lighting.EnvironmentSpecularScale = 1
		game.Lighting.ShadowSoftness = 0.2

	elseif settingsFrame.TextBox.Text == "Light Mode" then 
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