--!strict
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local rad = math.rad
local Rot = CFrame.new()

local function GetRollAngle()
	local Character = Player.Character

	if not Character then
		return
	end

	local Cf = Camera.CFrame

	return -Cf.RightVector:Dot(Character.Humanoid.MoveDirection)
end

RunService:BindToRenderStep("RotateCameraInDirectionPlayerIsGoing", Enum.RenderPriority.Camera.Value + 1, function()
	local Roll = GetRollAngle() * 4
	Rot = Rot:Lerp(CFrame.Angles(0, 0, rad(Roll)), 0.075)

	Camera.CFrame *= Rot
end)

RunService.RenderStepped:Connect(function(deltaTime: number)
	-- offset the camera similar to shift lock
	local offset = Vector3.new(0, 0, 0)
	local character = Player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local moveDirection = humanoid.MoveDirection
			offset = Vector3.new(moveDirection.Z, 0, -moveDirection.X) * 2
		end
	end
end)
