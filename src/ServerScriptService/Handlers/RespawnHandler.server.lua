local RespawnEvent = game:GetService("ReplicatedStorage").RemoteEvents.RespawnPlayer
local Analytics = game:GetService("AnalyticsService")

-- lets listen for our event.

RespawnEvent.OnServerEvent:Connect(function(player: Player) 
	player:LoadCharacter()
	task.wait(1)
	Analytics:LogOnboardingFunnelStepEvent(
		player,
		3,
		"Death"
	)
end)