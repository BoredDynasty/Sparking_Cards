local Teleporter = {}

-- // Services
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- // Variables
local JoinQueueEvent = ReplicatedStorage.RemoteEvents.JoinQueueEvent
local FloodDelay = 15
local RetryDelay = 20

-- // Functions

--[=[
    @function Teleport
        @param players table
        @param place number
--]=]
local function Teleport(players: { Player }, place: number)
	local numPlayers = 0
	local attempts = 0
	local attemptLimit = 5
	local success, result

	assert(place)
	assert(players.Data)

	for i: number, _ in players.Data do
		numPlayers = numPlayers + i
	end
	if numPlayers < 0 then
		numPlayers = false -- So assertion can work
		return
	end

	repeat
		success, result = pcall(function()
			return TeleportService:TeleportAsync(place, players)
		end)
		attempts = attempts + 1
	until success or attempts == attemptLimit

	if attempts == attemptLimit then
		MessagingService:PublishAsync("TeleportFailed")
	end

	return assert(numPlayers), result
end

local function addToQueue(_, players: { Player }, place)
	local teleported = {
		["Data"] = {},
	}
	for i, player: Player in players do
		table.insert(teleported.Data, player)
		if #player >= 2 then
			MessagingService:PublishAsync("TeleportedQueue", players)
			Teleport(players, place)
			table.clear(players)
			break
		end
	end
end

function Teleporter.Teleport(players: { Player }, place: number)
	local _, results = Teleport(players, place)
	if results == Enum.TeleportResult.Failure then
		MessagingService:PublishAsync("TeleportFailed", game.JobId)
	end
	return results
end

MessagingService:SubscribeAsync("AddQueue", addToQueue)
MessagingService:SubscribeAsync("TeleportFailed")

return Teleporter
