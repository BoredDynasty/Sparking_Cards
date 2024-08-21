local stat = "Cards" --Change to your stat name
local startamount = 5 --Change to how much points the player will start out with


local DataStore = game:GetService("DataStoreService")
local ds = DataStore:GetDataStore("LeaderStatCards")

--Don't worry about the rest of the code, except for line 25.
game.Players.PlayerAdded:connect(function(player)
local leader = Instance.new("Folder",player)
leader.Name = "leaderstats"
local Cards = Instance.new("IntValue",leader)
Cards.Name = "Cards"
Cards.Value = ds:GetAsync(player.UserId) or startamount
ds:SetAsync(player.UserId, Cards.Value)
Cards.Changed:connect(function()
ds:SetAsync(player.UserId, Cards.Value)
end)
end)

--[[local AutoSaveWaitTime = math.random(100, 200)

local notificationData = {
	Type = "Saving",
}

local remotes = game.ReplicatedStorage:WaitForChild("RemoteEvents")
local notificationRE = remotes:WaitForChild("CreateNotification")


function AutoSave(player)
	ds:SetAsync(player.UserId, player.leaderstats.Card.Value)
	notificationRE:FireClient(player, notificationData)
end

game.Players.PlayerRemoving:connect(function(player)
ds:SetAsync(player.UserId, player.leaderstats.Cards.Value) --Change "Points" to the name of your leaderstat.
end)

while true do
	wait(AutoSaveWaitTime)
	AutoSave()
end
--]]