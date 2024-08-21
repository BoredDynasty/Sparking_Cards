local Plr = script.Parent
local Hum = Plr.Humanoid
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Set the initial and maximum walk speed
local initialWalkSpeed = 20
local maxWalkSpeed = 32

Hum.WalkSpeed = initialWalkSpeed

local isJumping = false

Hum.Jumping:Connect(function()
	if not isJumping then
		isJumping = true
		-- Increase WalkSpeed while jumping
		for i = initialWalkSpeed, maxWalkSpeed, 1 do
			Hum.WalkSpeed = i
			wait(0.1)
		end
		isJumping = false
	end
end)

Hum.FreeFalling:Connect(function()
	-- Reset WalkSpeed when the player is no longer jumping
	for i = maxWalkSpeed, initialWalkSpeed, -1 do
		Hum.WalkSpeed = i
		wait(0.1)
	end
end)

local fovTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

RunService.Heartbeat:Connect(function()
	local targetFOV = 70 + (Hum.WalkSpeed - initialWalkSpeed) * 2
	local currentFOV = Camera.FieldOfView

	-- Tween to the target FOV
	local fovTween = TweenService:Create(Camera, fovTweenInfo, { FieldOfView = targetFOV })
	fovTween:Play()
end)
