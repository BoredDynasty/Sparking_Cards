--!strict
-- Discord Webhooks

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SendWebhook = ReplicatedStorage.RemoteEvents:FindFirstChildOfClass("UnreliableRemoteEvent") -- so the client can also send webhooks hehe

local PostClass = require(ReplicatedStorage.Classes.PostClass)

_G.Red = 15548997
_G.Grey = 3426654
print(_VERSION)

game.Players.PlayerAdded:Connect(function(plr: Player)
	PostClass.PostAsync(
		"Player Joined",
		plr.Name
			.. " has joined [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS), UserID: "
			.. plr.UserId
	)

	plr.Chatted:Connect(function(msg)
		PostClass.PostAsync("Player Chatted ", plr.Name, "The Player says [ " .. msg .. "]", 3426654)
	end)
end)

game.Players.PlayerRemoving:Connect(function(plr: Player)
	PostClass.PostAsync(
		"Player Left",
		plr.Name
			.. " has Left [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS), UserID: "
			.. plr.UserId,
		nil,
		15548997
	)
end)

SendWebhook.OnServerEvent:Connect(function(player, name, playerName, Text, color)
	PostClass.PostAsync(name, playerName, Text, color)
end)

-- Just to notify the player.
print("HTTP Service is enabled.")
print("Webhooks are enabled. -- For Chat Logs and Join Logs. Just so you know.")
