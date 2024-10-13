--!nocheck
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataClass = require(ReplicatedStorage.Classes.DataStoreClass)

-- datastores are now modulized

Players.PlayerAdded:Connect(function(player)
	DataClass.PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataClass.PlayerRemoving(player)
end)

game:BindToClose(DataClass.StartBindToClose)
