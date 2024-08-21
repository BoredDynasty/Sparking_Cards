local LetterboxRemote = game.ReplicatedStorage.RemoteEvents.NewDialogue

local message = script.Parent:GetAttribute("DialogueText")
local DissapearTime = script.Parent:GetAttribute("DissapearTime")
local Camera = script.Parent:GetAttribute("CameraBool")

local db = false

local HapticsService = game:GetService("HapticService")

local Player = game:GetService("Players")

Player.PlayerAdded:Connect(function(player: Player)
	script.Parent.Touched:Connect(function(hit)
		if db == false then
			db = true
			local character = hit.Parent
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then
				HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 3.5)
				task.wait(0.2)
				HapticsService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
				LetterboxRemote:FireClient(player, message, DissapearTime, Camera)
				print("Dialogue Request Processed")
				task.wait(tonumber(DissapearTime - 3))
				db = false
			end
		end
	end)
end)