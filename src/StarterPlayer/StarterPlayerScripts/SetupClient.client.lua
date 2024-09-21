--!nocheck
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Mouse = Players.LocalPlayer:GetMouse()

local WindShake = require(script.Parent:WaitForChild("WindShake"))

local NewChatRE: UnreliableRemoteEvent = ReplicatedStorage:WaitForChild("ChatMessageGlobal")

WindShake:Init({
	MatchWorkspaceWind = false,
})

WindShake:UpdateObjectSettings({

	WindDirection = Vector3.new(1, 0.7, 0.5),
	WindPower = 20,
	WindSpeed = 1.5,
})

local GloveR = script.gloverightPlayer
local GloveL = script.gloveleftPlayer

Players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(character: Model)
		local att = Instance.new("WeldConstraint")
		local att2 = Instance.new("WeldConstraint")

		local GloveRClone = GloveR:Clone()
		local GloveLClone = GloveL:Clone()

		local RightHand = character:FindFirstChild("Right Arm")
		local LeftHand = character:WaitForChild("Left Arm")

		GloveRClone.Parent = RightHand
		GloveLClone.Parent = LeftHand

		att.Parent = GloveRClone
		att.Part0 = GloveRClone
		att.Part1 = RightHand
		--att.C0.Rotation = CFrame.fromOrientation(0, 90, 90)

		att2.Parent = GloveLClone
		att2.Part0 = GloveLClone
		att2.Part1 = LeftHand
		--att2.C0.Rotation = CFrame.fromOrientation(0, -90, 90)
	end)
end)

local function chatMakeSystemMessage(message)
	local channel = TextChatService:WaitForChild("RBXSystem")
	channel:DisplaySystemMessage({
		Text = message,
	})
end

local MainCursor = "rbxasset://SystemCursors/Arrow"

Mouse.Icon = MainCursor

NewChatRE.OnClientEvent:Connect()
