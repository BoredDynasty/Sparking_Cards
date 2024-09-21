--!strict
local Class = {}
Class.__index = Class

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local AnalyticsClass = require(ReplicatedStorage.Classes.AnalyticsClass)

-- Location Module

function Class.PlayerEnteredArea(areaName: string, player: Player): string
	print(player.Name .. " has reached ".. areaName)
	return "The player has reached " .. areaName
end



return Class
