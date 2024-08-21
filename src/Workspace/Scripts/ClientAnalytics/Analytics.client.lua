local AnalyticsService = game:GetService("AnalyticsService")
local Players = game:GetService("Players")
local HTTPService = game:GetService("HttpService")

local FunnelSessionID = HTTPService:GenerateGUID(false)

game.Workspace.Subway.Vents.TestingAreaVent.Frame.ClickDetector.MouseClick:Connect(function(player) 
	AnalyticsService:LogFunnelStepEvent(
		player,
		"Baby Steps",
		FunnelSessionID,
		1,
		"Visit The Testing Grounds"
	)
end)

