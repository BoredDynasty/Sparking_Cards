--!strict
local Class = {}
Class = Class.__index

Class.Depth = 64
Class.HeightOffset = 2
Class.FieldOfView = 20

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local CurrentCamera = workspace.CurrentCamera
local Connection

function Class.StartCamera(Depth, HeightOffset, FieldOfView)
	if not Depth and HeightOffset and FieldOfView then
		Depth = Class.Depth
		HeightOffset = Class.HeightOffset
		FieldOfView = Class.FieldOfView
	end

	Connection = RunService.RenderStepped:Connect(function()
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.FieldOfView = FieldOfView

		local character = Players.LocalPlayer.Character
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local playerPosition = humanoidRootPart.Position + Vector3.yAxis * HeightOffset
			local cameraPosition = playerPosition + Vector3.one * Depth
			CurrentCamera.CFrame = CFrame.lookAt(cameraPosition, playerPosition)
		end
	end)
end

function Class.StopCamera()
	Connection:Disconnect()
end

return Class
