--!strict

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

PostClass.SetNewURL("http://worldtimeapi.org/api/timezone/America/New_York") -- We need to set a new URL so we can get the current time in the real world
-- We'll also have it as new york for now.
-- TODO Make this more precise
local RequestedData = PostClass.RequestAsync()

function updateLighting()
	local UnixTime = RequestedData.Data.unixtime
	local formattedDate = DateTime
		.fromUnixTimestamp(UnixTime) -- Our new data returns the unix timestamp.
		:ToUniversalTime()
	Lighting.ClockTime = tonumber(formattedDate)
end

RunService.Heartbeat:Connect(updateLighting)
