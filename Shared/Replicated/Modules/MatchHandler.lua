local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local DataStoreService = game:GetService("DataStoreService")

local MatchmakingModule = {}
local queueDataStore = DataStoreService:GetDataStore("MatchmakingQueue")

local function addToGlobalQueue(player)
	local success, err = pcall(function()
		local queue = queueDataStore:GetAsync("Queue") or {}
		table.insert(queue, player.UserId)
		queueDataStore:SetAsync("Queue", queue)
		MessagingService:PublishAsync("MatchmakingQueueUpdate")
	end)
	assert(success, `Failed to add {player} to global queue: {err}!!`)
end

local function checkForMatch()
	local success, queue = pcall(function()
		return queueDataStore:GetAsync("Queue") or {}
	end)
	if success and #queue >= 2 then
		local player1Id = table.remove(queue, 1)
		local player2Id = table.remove(queue, 1)
		queueDataStore:SetAsync("Queue", queue)

		local player1 = Players:GetPlayerByUserId(player1Id)
		local player2 = Players:GetPlayerByUserId(player2Id)

		if player1 and player2 then
			local placeId = 90845913624517 -- Match
			TeleportService:TeleportPartyAsync(placeId, { player1, player2 })
		end
	end
end

function MatchmakingModule.AddPlayerToQueue(player)
	if not game:GetService("RunService"):IsStudio() then
		addToGlobalQueue(player)
		checkForMatch()
	end
end

MessagingService:SubscribeAsync("MatchmakingQueueUpdate", function()
	if not game:GetService("RunService"):IsStudio() then
		checkForMatch()
	end
end)

return MatchmakingModule
