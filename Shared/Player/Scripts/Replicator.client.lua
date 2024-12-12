--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ReplicateRE: RemoteEvent = ReplicatedStorage.RemoteEvents:FindFirstChild("ReplicateCustscene")
local Camera = game.Workspace.CurrentCamera

local connection: RBXScriptConnection = nil

local otherCFrame = Camera.CFrame

ReplicateRE.OnClientEvent:Connect(function(character: Model, cutsceneFolder: Folder)
	if not connection then
		connection = RunService.RenderStepped:Connect(function(delta)
			local frames = (delta * 60)
			local steppedFrames: CFrameValue | IntValue = cutsceneFolder:FindFirstChild(tonumber(math.ceil(frames)))
			character.Humanoid.AutoRotate = false
			Camera.CameraType = Enum.CameraType.Scriptable
			if steppedFrames then
				Camera.CFrame = character.HumanoidRootPart.CFrame * steppedFrames.Value
			else
				connection:Disconnect()
				character.Humanoid.AutoRotate = true
				Camera.CameraType = Enum.CameraType.Custom
				Camera.CFrame = otherCFrame
			end
		end)
	end
end)
