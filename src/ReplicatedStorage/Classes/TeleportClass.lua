--!strict
local Class = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local AnalyticsService = game:GetService("AnalyticsService")

function Class.ReservedTeleportAsync(place: number, player: Player)
	local newServer = TeleportService:ReserveServer(place)
	TeleportService:Teleport(newServer, player)
end

function Class.TeleportAsync(place: number, player: Player)
	TeleportService:Teleport(place)
end

function Class.TeleportParty(place: number, player: table, matchID: string?)
	TeleportService:TeleportPartyAsync(place, player)
end

return Class
