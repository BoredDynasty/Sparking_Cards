--!nocheck
--!nolint

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Mouse = Players.LocalPlayer:GetMouse()

-- Gloves

local GloveR = script.gloverightPlayer
local GloveL = script.gloveleftPlayer

Players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(character: Model)
		local att = Instance.new("WeldConstraint")
		local att2 = Instance.new("WeldConstraint")

		local GloveRClone = GloveR:Clone()
		local GloveLClone = GloveL:Clone()

		local RightHand = character.RightArm
		local LeftHand = character.LeftArm

		GloveRClone.Parent = RightHand
		GloveLClone.Parent = LeftHand

		att.Parent = GloveRClone
		att.Part0 = GloveRClone
		att.Part1 = RightHand

		att2.Parent = GloveLClone
		att2.Part0 = GloveLClone
		att2.Part1 = LeftHand
	end)
end)

local player = Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input == Enum.KeyCode.LeftShift then
		player.Character.Humanoid.WalkSpeed = 16
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input == Enum.KeyCode.LeftShift then
		player.Character.Humanoid.WalkSpeed = 14
	end
end)
