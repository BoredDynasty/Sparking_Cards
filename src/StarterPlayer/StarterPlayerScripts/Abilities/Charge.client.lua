-- // Services

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- // Variables

local Particle = script.ChargeVFX
local AnimationStart = "rbxassetid://18900211493"

local Debounce = false

-- // Functions

local function Charge(key)
	if key.KeyCode == Enum.KeyCode.C then
		if Debounce == false then
			Debounce = true
			local Animation = Instance.new("Animation")
			Animation.AnimationId = AnimationStart
			local Track = Players.LocalPlayer.Character:FindFirstChild("Humanoid"):LoadAnimation(Animation)
			Track:Play()
			local Part = Particle:Clone()
			Part.Parent = Players.LocalPlayer.Character:FindFirstChild("Torso")
			Part.CFrame = Players.LocalPlayer.Character:FindFirstChild("Torso").CFrame
			Part.DBZ_Beam_Charge:Play()
			local att = Instance.new("WeldConstraint")
			att.Parent = Part
			att.Part0 = Part
			att.Part1 = Players.LocalPlayer.Character:FindFirstChild("Torso")
			Players.LocalPlayer.Character:FindFirstChild("Torso").Anchored = true
			Players.LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 0
			task.wait(5)
			Part:Destroy()
			Track:Stop()
		end
	end
	task.wait(30)
	Debounce = false
end

UserInputService.InputBegan:Connect(Charge)