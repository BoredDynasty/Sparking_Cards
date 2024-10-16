--!nocheck
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LoadingClass = require(ReplicatedStorage.Classes.LoadingClass)

local player = Players.LocalPlayer

for index, tag in pairs(CollectionService:GetTagged("TeleportPart")) do
	local Teleport = tag

	local destination = Teleport:GetAttribute("Destination")

	Teleport.ClickDetector.MouseClick:Connect(function(player)
		LoadingClass.New(1.2, player)
		task.wait(1)
		player.Character.HumanoidRootPart:PivotTo(destination)
	end)
end
