--!strict
local Class = {}
Class.__index = Class
Class.BanTime = 2486400 -- ~one day
Class.Message = "Player Banned / Banned"
Class.Duration = -1 -- -1 is a permanant ban
Class.ExcludeAltAccounts = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

function Class.SetDefaultSettings(BanTime: number, GlobalMessage: string, Duration: number, ExcludeAltAccounts: boolean)
	Class.BanTime = BanTime
	Class.Message = GlobalMessage
	Class.Duration = Duration
	Class.ExcludeAltAccounts = ExcludeAltAccounts
end

function Class:Kick(player: Player)
	local playerToKick = game.Players:FindFirstChild(player.Name)

	if playerToKick then
		playerToKick:Kick(tostring(Class.Message))
	else
		print("Player not found!")
	end
end

local function getNextBanDuration(a, b)
	a = Players:GetBanHistoryAsync(b)
	return a * 3
end

function Class:BanAsync(player: Player, applyToUniverse, duration: number, PrivateReason: string)
	local banHistoryPages = Players:GetBanHistoryAsync(player.UserId)

	local config: BanConfigType = {
		UserIds = { player.UserId },
		Duration = Class.Duration,
		DisplayReason = Class.Message,
		PrivateReason = tostring(PrivateReason),
		ExcludeAltAccounts = Class.ExcludeAltAccounts,
		ApplyToUniverse = applyToUniverse,
	}

	PostClass.PostAsync("Ban History Pages for " .. player.Name, tostring(Players:GetBanHistoryAsync(player.UserId)))

	local success, err = pcall(function()
		PostClass.PostAsync("Banned Player", table.concat(config, ",    ")) -- take some drastic measures
		return Players:BanAsync(config)
	end)
end

return Class
