--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)
local TeleportClass = require(ReplicatedStorage.Classes.TeleportClass)
local AnalyticsClass = require(ReplicatedStorage.Classes.AnalyticsClass)
local PostClass = require(ReplicatedStorage.Classes.PostClass)

local TeleportRE = Instance.new("RemoteEvent", ReplicatedStorage)
TeleportRE.Name = "TeleportRE"

local queueTable = {}

local function teleport(player: Player, queue): ()
	if not table.find(queueTable, player) then
		table.insert(queueTable, player)
		print(string.format("Player Teleported \n" .. player.Name, "%q"))
		AnalyticsClass.LogCustomEvent(player, "Player entered a match")
		DataStoreClass.SaveData(player) -- Gotta save before we leave
		local matchID = PostClass.GenerateGUID(true)
		TeleportClass.TeleportParty(0, queueTable) -- TODO add a place number lmao
		task.wait(5)
		table.remove(queueTable, table.find(queueTable, player))
	end
end

TeleportRE.OnServerEvent:Connect(teleport)
