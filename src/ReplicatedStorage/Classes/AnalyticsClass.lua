--!strict

local Class = {}

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local DataClass = require(ReplicatedStorage.Classes.DataStoreClass)

local GUID = PostClass.GenerateGUID(true)

function Class.LogEconomyEvent(player: Player, type, amount, transaction)
	if not player then
		player = Players.LocalPlayer
	end

	Analytics:LogEconomyEvent(
		player,
		type,
		"Cards",
		amount,
		player:FindFirstChild("leaderstats").Cards.Value,
		transaction
	)
	return "Log Sent"
end

function Class.LogCustomEvent(player: Player, name)
	if not player then
		player = Players.LocalPlayer
	end

	Analytics:LogCustomEvent(player, name, 1)
	return "Log Sent"
end

function Class.LogOnboardingFunnelStepEvent(player: Player, name, step)
	Analytics:LogOnboardingFunnelStepEvent(player, step, name)
	return "Log Sent"
end

return Class
