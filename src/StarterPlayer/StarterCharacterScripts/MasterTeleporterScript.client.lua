--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = ReplicatedStorage.Classes.LoadingClass

local TeleportParts = {
	TestingGrounds = workspace.testingAreaSpawn,
	Spawn = workspace.Subway.SpawnLocation.Part,
	TheRoadManhole = workspace.Maps.TheRoad["Meshes/Manhole"],
}

local Vents = {
	TestingGroundsVent = workspace.Subway.Vents.TestingAreaVent,
	TheRoadVent = workspace.Subway.Vents.TheRoadVent,
}

local function teleport(player: Player, where: CFrame, size)
	if not size then
		size = 0.5
	end
	task.wait(0.01)
	Class.New(size)
	player.Character:PivotTo(where)
end

Vents.TestingGroundsVent.Frame.ClickDetector.MouseClick:Connect(function(player)
	teleport(player, TeleportParts.TestingGrounds.CFrame, 0.7)
end)

Vents.TheRoadVent.Frame.ClickDetector.MouseClick:Connect(function(Player)
	teleport(Player, TeleportParts.TheRoadManhole.CFrame, 1.2)
end)

TeleportParts.TheRoadManhole.ClickDetector.MouseClick:Connect(function(player)
	teleport(player, TeleportParts.Spawn.CFrame)
end)

TeleportParts.TestingGrounds.ClickDetector.MouseClick:Connect(function(player)
	teleport(player, TeleportParts.Spawn, 1.2)
end)
