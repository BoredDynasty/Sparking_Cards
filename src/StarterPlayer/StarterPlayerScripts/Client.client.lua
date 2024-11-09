--!nocheck
--!nolint

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Hint = require(ReplicatedStorage.Modules.Hint)
local SoundManager = require(ReplicatedStorage.Modules.SoundManager)

local Mouse = Players.LocalPlayer:GetMouse()

local places = {
	["Match"] = 90845913624517,
}

-- Gloves

local GloveR = script.gloverightPlayer
local GloveL = script.gloveleftPlayer

Players.PlayerAdded:Connect(function(player: Player)
	-- SoundManager.Music(ReplicatedStorage.Music, true)
	player.CharacterAdded:Connect(function(character: Model)
		--
	end)
	player.Chatted:Connect(function(message)
		if message == "@match" then
			ReplicatedStorage.RemoteEvents.JoinQueueEvent:InvokeServer({ player }, places["Match"])
			Hint.newHint("Searching for Match.", player)
		end
	end)
end)

local player = Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	--
	if input == Enum.KeyCode.LeftShift then
		player.Character.Humanoid.WalkSpeed = 16
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	--
	if input == Enum.KeyCode.LeftShift then
		player.Character.Humanoid.WalkSpeed = 14
	end
end)
