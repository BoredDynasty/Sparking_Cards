local LetterboxRemote = game.ReplicatedStorage.RemoteEvents.NewDialogue
local LetterBox = game.ReplicatedStorage.RemoteEvents.SpecificUIHide.Letterbox

local message = script.Parent:GetAttribute("DialogueText")
local DissapearTime = script.Parent:GetAttribute("DissapearTime")
local Camera = script.Parent:GetAttribute("CameraBool")
local LookAtTime = script.Parent:GetAttribute("LookAtTime")
local CameraPosition = script.Parent:GetAttribute("CameraPosition")

local Sound = script.MoonSound
local SoundService = game:GetService("SoundService")

local db = false

local lighting = game:GetService("Lighting")

local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(
	3,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

script.Parent.Touched:Connect(function(hit)
	if db == false then
		db = true
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			
			local HapticService = game:GetService("HapticService")

			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 3.5)
			task.wait(tonumber(LookAtTime))
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)

		end
		TweenService:Create(lighting, TweenParams, {ClockTime = 4}):Play()
		task.wait(0.5)
		LetterboxRemote:FireAllClients(message, DissapearTime, Camera, CameraPosition)
		LetterBox:FireAllClients(LookAtTime)
		SoundService.AmbientReverb = Enum.ReverbType.Cave
		Sound:Play()
		task.wait(tonumber(LookAtTime))
		TweenService:Create(lighting, TweenParams, {ClockTime = 7}):Play()
		
		print("Cutscene Request Processed")

		task.wait(LookAtTime)
		if humanoid then
			humanoid.WalkSpeed = 14
		end
		SoundService.AmbientReverb = Enum.ReverbType.NoReverb
	end

	task.wait(tonumber(DissapearTime - 3))
	db = false

end)
