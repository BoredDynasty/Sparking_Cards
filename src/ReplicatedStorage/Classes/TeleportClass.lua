--!strict
local Class = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local AnalyticsService = game:GetService("AnalyticsService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

function Class.ReservedTeleportAsync(place: number, player: Player)
	local newServer = TeleportService:ReserveServer(place)
	TeleportService:Teleport(newServer, player)

	PostClass.PostAsync("Sent Player To Remote Universe", "PlaceID / " .. place, " Reserved Server")
end

function Class.TeleportAsync(place: number, player: Player)
	TeleportService:Teleport(place)

	PostClass.PostAsync("Sent Player To Remote Universe", "PlaceID / " .. place, " Normal")
end

function Class.TeleportParty(place: number, player: table)
	TeleportService:TeleportPartyAsync(place, player)

	PostClass.PostAsync("Sent Player To Remote Universe", "PlaceID / " .. place, " Party")
end

return Class
