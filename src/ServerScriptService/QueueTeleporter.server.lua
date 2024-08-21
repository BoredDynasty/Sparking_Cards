--!strict
local Remote = game.ReplicatedStorage.RemoteEvents.Queue.Queue1

local teleportPart = workspace:WaitForChild("TeleportPart")
if not teleportPart then
	warn("TeleportPart not found in workspace")
	return
end

Remote.OnServerEvent:Connect(function(player: Player, PlayersInQueue)
	local rootPart = PlayersInQueue.Character:WaitForChild("HumanoidRootPart")
	rootPart:PivotTo(teleportPart)
end)
