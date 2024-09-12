--!strict
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

local Turn = 0

local Lerp = function(a, b, t)
	return a + (b - a) * t
end
--[[
local swayEnabled = false
local swayAmount = Vector2.new(0.1, 0.1)
local smoothness = 0.1

-- Store original camera offset
local originalCameraOffset = Vector3.new(0, 0, 0)
local currentOffset = originalCameraOffset

-- Function to update camera position based on mouse movement
local function updateCamera()
	local mouseX = (mouse.X - (Camera.ViewportSize.X / 2)) / (Camera.ViewportSize.X / 2)
	local mouseY = (mouse.Y - (Camera.ViewportSize.Y / 2)) / (Camera.ViewportSize.Y / 2)

	-- Calculate the target offset based on mouse position
	local targetOffset = Vector3.new(mouseX * swayAmount.X, mouseY * swayAmount.Y, 0)

	-- Smoothly transition to the target offset
	currentOffset = currentOffset:Lerp(targetOffset, smoothness)

	-- Apply the offset to the camera's CFrame
	Camera.CFrame = Camera.CFrame * CFrame.new(currentOffset)
end
--]]
RunService:BindToRenderStep("CameraSway", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
	local MouseDelta = UserInputService:GetMouseDelta()

	Turn = Lerp(Turn, math.clamp(MouseDelta.X, -5, 5), (5 * deltaTime))

	Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, math.rad(Turn))
end)
--[[
local function lockCamera()
	local currentCFrame = Camera.CFrame
	local lookVector = currentCFrame.LookVector

	-- Lock the Y-axis rotation by setting it to 0
	local lockedLookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit

	-- Reconstruct the CFrame with the locked Y rotation
	local newCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + lockedLookVector)

	Camera.CFrame = newCFrame
end

RunService:BindToRenderStep("CameraYLock", Enum.RenderPriority.Camera.Value + 23, lockCamera)
--]]
