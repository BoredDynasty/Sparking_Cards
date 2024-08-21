local LetterboxRemote = game.ReplicatedStorage.RemoteEvents.SpecificUIHide.NewWarning
local Click = script.Parent.ClickDetector

local Camera = workspace.CurrentCamera
local	DefaultFov = Camera.FieldOfView
local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

local blur = game.Lighting:WaitForChild("Blur")

local message = script.Parent:GetAttribute("WarningText")
local DissapearTime = script.Parent:GetAttribute("DissapearTime")

local sound = script.Parent.question

local db = false

local HapticService = game:GetService("HapticService")

Click.MouseClick:Connect(function(playerWhoClicked: Player)
	if db == false then
		db = true
		local character = playerWhoClicked.Character
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0

			-- TweenService:Create(Camera, TweenParams, {FieldOfView = 20}):Play()
			-- TweenService:Create(blur, TweenParams, {Size = 20}):Play()

			sound:Play()

			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 3.5)
			task.wait(0.2)
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
		end

		LetterboxRemote:FireAllClients(message, DissapearTime)
		print("Warning Request Processed")

		task.wait(tonumber(DissapearTime))
		humanoid.WalkSpeed = 14
		-- TweenService:Create(Camera, TweenParams, {FieldOfView = 70}):Play()
		-- TweenService:Create(blur, TweenParams, {Size = 0}):Play()
		db = false
	end
end)
