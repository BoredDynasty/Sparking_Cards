local clickDetect = script.Parent.ClickDetector
local players = game.Players

local mapSize = 2

players.PlayerAdded:Connect(function(player: Player)
	clickDetect.MouseClick:Connect(function(playerWhoClicked: Player)  
		if playerWhoClicked.Character then
			game.ReplicatedStorage.RemoteEvents.SpecificUIHide.LoadingArea:FireClient(player, mapSize)
			task.wait(1)
			playerWhoClicked.Character:PivotTo(workspace.Maps.TheRoad["Meshes/Manhole"].SpawnPart.CFrame)
		end
	end)
end)