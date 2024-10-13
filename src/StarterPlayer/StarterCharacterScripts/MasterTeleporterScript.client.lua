--!nocheck
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeleportClass = require(ReplicatedStorage.Classes.TeleportClass)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)
local LoadingClass = require(ReplicatedStorage.Classes.LoadingClass)

local player = Players.LocalPlayer

for index, tag in pairs(CollectionService:GetTagged("TeleportPart")) do
	local Teleport = tag

	local destination = Teleport:GetAttribute("Destination")

	if Teleport:GetAttribute("RemoteServer") then
		TeleportClass.TeleportAsync(Teleport:GetAttribute("RemoteServer"), player)
	end

	Teleport.ClickDetector.MouseClick:Connect(function(player)
		LoadingClass.New(1.2, player)
		task.wait(1)
		player.Character.HumanoidRootPart:PivotTo(destination)
	end)
end
