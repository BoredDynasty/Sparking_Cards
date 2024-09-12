--!strict
-- Discord Webhooks
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local SendWebhook = ReplicatedStorage.RemoteEvents.SendWebhook -- so the client can also send webhooks hehe

local PostClass = require(ReplicatedStorage.Classes.PostClass)

_G.Red = 15548997
_G.Grey = 3426654
_G.Green = 5763719
_G.Blue = 3447003
_G.Purple = 10181046
_G.Gold = 15844367
_G.DarkNavy = 2899536
_G.Yellow = 16776960
print(_VERSION) -- luau

local AnnoucementRemote = Instance.new("UnreliableRemoteEvent")
AnnoucementRemote.Parent = ReplicatedStorage
AnnoucementRemote.Name = "AnnoucementRemote"

Players.PlayerAdded:Connect(function(player: Player)
	PostClass.PostAsync(
		"Player Joined",
		player.Name
			.. " has joined [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS), UserID: "
			.. player.UserId
	)

	player.Chatted:Connect(function(message)
		local filterResults = {}
		local success, result = pcall(function()
			return TextService:FilterAndTranslateStringAsync(message, player.UserId)
		end)
		if success then
			filterResults[player.UserId] = result
		else -- Ahem, step aside Roblox. we'll do the moderating
			PostClass.PostAsync("Could not Filter Text | " .. player.UserId, success, result, _G.Purple)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	PostClass.PostAsync(
		"Player Left",
		player.Name
			.. " has Left [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS), UserID: "
			.. player.UserId,
		nil,
		_G.Red
	)
end)

SendWebhook.OnServerEvent:Connect(
	function(player, name, playerName, Text, color) -- we also need the client to use HTTP service aswell ehehehe~!
		PostClass.PostAsync(name, playerName, Text, color)
	end
)

PostClass:Announce("Well now, this is in testing!")
