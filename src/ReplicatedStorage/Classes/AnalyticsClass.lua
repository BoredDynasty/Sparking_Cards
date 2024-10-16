--!strict

local Class = {}

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function Class.LogEconomyEvent(player, type, amount, transaction): string
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

function Class.LogCustomEvent(player: Player, name): string
	if not player then
		player = Players.LocalPlayer
	end

	Analytics:LogCustomEvent(player, name, 1)

	return "Log Sent"
end

function Class.LogOnboardingFunnelStepEvent(player: Player, name, step): string
	Analytics:LogOnboardingFunnelStepEvent(player, step, name)

	return "Log Sent"
end

function Class.LogProgressionEvent(
	player,
	pathName,
	progressionType: Enum.AnalyticsProgressionStatus,
	level,
	levelName
): string
	Analytics:LogProgressionEvent(player, pathName, progressionType, level, levelName)

	return "Log Sent"
end

return Class
