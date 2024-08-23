--!strict
-- Discord Webhooks

local webhook =
	"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"
local HTTP = game:GetService("HttpService")

local profileTemplate = '"http://www.roblox.com/Thumbs/Avatar.ashx?x=200&y=200&Format=Png&username="'

game.Players.PlayerAdded:Connect(function(plr: Player)
	local leaderstats = plr:WaitForChild("leaderstats")
	local data = {
		["embeds"] = {
			{
				["title"] = "Player Joined",
				["description"] = plr.Name
					.. " has joined [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS), UserID: "
					.. plr.UserId,
				["color"] = 5635967,
			},
		},
	}

	plr.Chatted:Connect(function(msg)
		local data = {
			["embeds"] = {
				{
					["title"] = plr.Name,
					["description"] = plr.Name .. " says: " .. msg,
					["color"] = 16777087,
				},
			},
		}

		local finaldata = HTTP:JSONEncode(data)
		task.wait(1)
		HTTP:PostAsync(webhook, finaldata)
		return "Log recieved!"
	end)

	local finaldata = HTTP:JSONEncode(data)
	HTTP:PostAsync(webhook, finaldata)
	return "Log recieved!"
end)

game.Players.PlayerRemoving:Connect(function(plr: Player)
	local data = {
		["embeds"] = {
			{
				["title"] = "Player Left",
				["description"] = plr.Name
					.. " has left [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS). UserID: "
					.. plr.UserId,
				["color"] = 16732240,
			},
		},
	}
	local finaldata = HTTP:JSONEncode(data)
	HTTP:PostAsync(webhook, finaldata)
	return "Log recieved!"
end)

-- Just to notify the player.
print("HTTP Service is enabled.")
print("Webhooks are enabled. -- For Chat Logs and Join Logs. Just so you know.")
