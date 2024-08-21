--!strict
-- This script will give a player a "coin" multiplier for however long the player stays in the game

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local elaspsedTime = 0
local Multiplier = elaspsedTime / 90

local function Stepped()
	elaspsedTime = elaspsedTime + 0.01
	elaspsedTime = Multiplier
	print(tonumber(elaspsedTime))
end

RunService.Stepped:Connect(Stepped)
