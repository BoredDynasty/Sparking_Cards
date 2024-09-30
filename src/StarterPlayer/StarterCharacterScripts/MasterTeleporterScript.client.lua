--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportClass = require(ReplicatedStorage.Classes.TeleportClass)
local PostClass = require(ReplicatedStorage.Classes.PostClass)

local player = Players.LocalPlayer

for index, tag in pairs(CollectionService:GetTagged("TeleportPart")) do
	local Teleport = tag

	local destination = Teleport:GetAttribute("Destination")
	if Teleport:GetAttribute("RemoteServer") then
		TeleportClass.TeleportAsync(Teleport:GetAttribute("RemoteServer"), player)
	end

	Teleport.ClickDetector.MouseClick:Connect(function(player)
		player.Character.HumanoidRootPart:PivotTo(destination)
	end)
end
