--!nonstrict

local Match = {}
local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MemoryStoreService = game:GetService("MemoryStoreService")
local TeleportService = game:GetService("TeleportService")

local SafeTeleporter = require(ReplicatedStorage.Modules.SafeTeleporter)

-- // Variables
local queueMap = MemoryStoreService:GetSortedMap("queue")
local debounce = {}
local maximum = 2
local minimum = 2
local place = 0

function Match.new()
	--Check when enough players are in the queue to teleport players
	local lastOverMin = tick()

	while task.wait(1) do
		local success, queuedPlayers = pcall(function()
			return queueMap:GetRangeAsync(Enum.SortDirection.Descending, maximum)
		end)

		if success then
			local amountQueued = 0
			for _, _ in pairs(queuedPlayers) do
				amountQueued += 1
			end
			if amountQueued < minimum then
				lastOverMin = tick()
			end

			--[[
            Wait 20 seconds after the minimum players is reached to allow for more players to join the queue
			Or instantly queue once the maximum players is reached
            --]]

			local timeOverMin = tick() - lastOverMin

			if timeOverMin >= 20 or amountQueued == maximum then
				for _, data in pairs(queuedPlayers) do
					local userId = data.value
					local player = Players:GetPlayerByUserId(userId)

					if player then
						SafeTeleporter(place, queuedPlayers)
					end
				end
			end
		end
	end
end

function Match.addPlayer(player)
	return queueMap:SetAsync(player.UserId, player.UserId, 3600), queueMap -- 60 Minutes
end

function Match.removePlayer(player)
	return queueMap:RemoveAsync(player.UserId)
end

function Match:handleNewQueue(player, inQueue)
	if not table.find(debounce, player) then
		if inQueue == true then
			pcall(Match.removePlayer, player)
		else
			pcall(Match.addPlayer, player)
		end
	end
end

return Match
