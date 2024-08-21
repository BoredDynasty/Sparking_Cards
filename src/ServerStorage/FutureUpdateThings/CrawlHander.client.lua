--// Configuration
local keybind = "C"
local animationId = 18868853543
  

--// Variables
local UserInputService = game:GetService("UserInputService")

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = 'rbxassetid://' .. animationId

local animationTrack = humanoid:WaitForChild("Animator"):LoadAnimation(animation)
animationTrack.Priority = Enum.AnimationPriority.Action

local crouching = false
local forceCrawl = script:GetAttribute("ForceCrawl")

--// Functions
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end

	if input.KeyCode == Enum.KeyCode[keybind] then
		if crouching then
			humanoid.WalkSpeed = 14
			crouching = false
			animationTrack:Stop()
			character.HumanoidRootPart.CanCollide =  true
		else
			humanoid.WalkSpeed = 6
			crouching = true
			animationTrack:Play()
			character.HumanoidRootPart.CanCollide =  false
		end
	end
end)

if forceCrawl == true then
	humanoid.WalkSpeed = 6
	crouching = true
	animationTrack:Play()
	character.HumanoidRootPart.CanCollide =  false
else
	humanoid.WalkSpeed = 14
	crouching = false
	animationTrack:Stop()
	character.HumanoidRootPart.CanCollide =  true
end

