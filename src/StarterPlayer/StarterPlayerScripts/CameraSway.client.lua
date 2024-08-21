local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Turn = 0

local Lerp = function(a, b, t)
	return a + (b - a) * t
end;

RunService:BindToRenderStep("CameraSway", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
	local MouseDelta = UserInputService:GetMouseDelta()

	Turn = Lerp(Turn, math.clamp(MouseDelta.X, -5, 5), (5 * deltaTime))

	Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, math.rad(Turn))
end)
