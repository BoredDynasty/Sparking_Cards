--!strict

---@class Analytic
local Analytic = {}

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function Analytic.LogEconomyEvent(player, type, amount, transaction): string
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

function Analytic.LogCustomEvent(player: Player, name): string
	if not player then
		player = Players.LocalPlayer
	end

	Analytics:LogCustomEvent(player, name, 1)

	return "Log Sent"
end

function Analytic.LogOnboardingFunnelStepEvent(player: Player, name, step): string
	Analytics:LogOnboardingFunnelStepEvent(player, step, name)

	return "Log Sent"
end

function Analytic.LogProgressionEvent(
	player,
	pathName,
	progressionType: Enum.AnalyticsProgressionStatus,
	level,
	levelName
): string
	Analytics:LogProgressionEvent(player, pathName, progressionType, level, levelName)

	return "Log Sent"
end

return Analytic
