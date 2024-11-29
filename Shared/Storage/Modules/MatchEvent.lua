--!nonstrict

local event = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Started = ReplicatedStorage.RemoteEvents.MatchStarted
local Ended = ReplicatedStorage.RemoteEvents.MatchEnded

local elaspedTime = 0
local clients = 0

event.Start = function()
	repeat
		task.wait(1)
		elaspedTime = elaspedTime + 1
	-- 30minutes
	until elaspedTime == 1800 or Ended.OnClientEvent
	return true
end

event.onClientsLoaded = function(a)
	clients = clients + a
	if clients == 2 then
		task.wait(15)
		event.Start()
	end
end

return event, elaspedTime
