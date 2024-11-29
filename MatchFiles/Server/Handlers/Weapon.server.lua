-- [TODO) Start Adding Weapons

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local MatchEvent = require(ServerStorage.Modules.MatchEvent)
local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)

local clientLoaded = ReplicatedStorage.RemoteEvents.ClientLoaded

clientLoaded.OnServerEvent:Connect(MatchEvent.onClientsLoaded)

local function retrieveWeaponry(player)
	local datastore: DataStore = DataStoreClass:GetDataStore("Cards")
	datastore = DataStoreClass:GetAsync(datastore, player.UserId) :: DataStore
	if datastore then
		-- // [TODO) Finish
	end
end

if MatchEvent.Start then
end
