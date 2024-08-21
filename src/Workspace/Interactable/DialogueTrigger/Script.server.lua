--!strict

local Remote = game:GetService("ReplicatedStorage").RemoteEvents.NewDialogue

local db = false

local Dialogue = script.Parent:GetAttribute("DialogueText")
local DissapearTime = script.Parent:GetAttribute("DissapearTime")
local CameraBool = script.Parent:GetAttribute("CameraBool")
local Player = game:GetService("Players")

Player.PlayerAdded:Connect(function(player: Player)
	script.Parent.ClickDetector.MouseClick:Connect(function(playerWhoClicked: Player)
		if db == false then
			db = true
			print("Sent FireAllClients()")
			Remote:FireClient(player, Dialogue, DissapearTime, CameraBool)
			task.wait(tonumber(DissapearTime))
			db = false
		end
	end)
end)