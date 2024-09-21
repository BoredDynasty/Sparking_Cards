--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Classes.TeleportClass)
local PostClass = require(ReplicatedStorage.Classes.PostClass)

local player = Players.LocalPlayer

local TeleportTag = "TeleportPart"
local TPTag = CollectionService:GetTagged(TeleportTag)

for index, tag in pairs(TPTag) do
	local Teleport = tag

	local destination = Teleport:GetAttribute("Destination")
	if Teleport:GetAttribute("RemoteServer") then
		Class.TeleportAsync(Teleport:GetAttribute("RemoteServer"), player)
	end

	Teleport.ClickDetector.MouseClick:Connect(function(player)
		player.Character.HumanoidRootPart:PivotTo(destination)
	end)
end