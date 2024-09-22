--!nocheck
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local PlayerGui = LocalPlayer.PlayerGui
local Camera = workspace.CurrentCamera

local Remote = ReplicatedStorage:FindFirstChild("CutsceneRemote") --/Change this to your path of the remote

function Cinematic(Target, Folder, AnimId) --/first arg is a which client will see animation // second is a HRP of humamoid on which anim will played // third arg is the animation ID to play
	local PP = Target
	local Animator = PP.Parent:WaitForChild("Humanoid").Animator
	local AnchorPart = Instance.new("Part", workspace)
	AnchorPart.Anchored = true
	local Weld = Instance.new("Weld", AnchorPart)
	Weld.Part0 = AnchorPart
	Weld.Part1 = PP
	local Anim = Instance.new("Animation")
	Anim.AnimationId = AnimId
	local Animation = Animator:LoadAnimation(Anim)
	Animation:Play()

	local CinematicsFolder = Folder

	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame

	Camera.CameraType = Enum.CameraType.Scriptable
	local FrameTime = 0
	local Connection

	Connection = RunService.RenderStepped:Connect(function(DT)
		local NewDT = DT * 60
		FrameTime += NewDT
		local NeededFrame = CinematicsFolder.Frames:FindFirstChild(tonumber(math.ceil(FrameTime)))
		local NeededFOV = CinematicsFolder.FOV:FindFirstChild(tonumber(math.ceil(FrameTime)))
		if NeededFrame then
			Character.Humanoid.AutoRotate = false
			game.StarterGui:SetCore("ResetButtonCallback", false)
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
			Camera.CFrame = Target.CFrame * NeededFrame.Value
			if NeededFOV then
				Camera.FieldOfView = tonumber(NeededFOV.Value)
			end
		else
			Connection:Disconnect()
			game.StarterGui:SetCore("ResetButtonCallback", true)
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			Character.Humanoid.AutoRotate = true
			Camera.CameraType = Enum.CameraType.Custom
			Camera.CFrame = CurrentCameraCFrame
			Camera.FieldOfView = 70
			Anim:Destroy()
		end

		Character.Humanoid.Died:Connect(function()
			Connection:Disconnect()
			game.StarterGui:SetCore("ResetButtonCallback", true)
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			Character.Humanoid.AutoRotate = true
			Camera.CameraType = Enum.CameraType.Custom
			Camera.CFrame = CurrentCameraCFrame
			Camera.FieldOfView = 70
			Anim:Destroy()
		end)
	end)
end

Remote.OnClientEvent:Connect(function(HumRP, Folder, AnimId)
	AnimId = "rbxassetid://" .. AnimId
	Cinematic(HumRP, Folder, AnimId)
end)
