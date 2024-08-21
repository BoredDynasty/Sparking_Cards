local clickDetect = script.Parent.ClickDetector
local players = game.Players

local mapSize = 0.5

players.PlayerAdded:Connect(function(player: Player)
	clickDetect.MouseClick:Connect(function(playerWhoClicked: Player)  
		if playerWhoClicked.Character then
			game.ReplicatedStorage.RemoteEvents.SpecificUIHide.LoadingArea:FireClient(player, mapSize)
			task.wait(1)
			playerWhoClicked.Character:PivotTo(workspace.testingAreaSpawn.CFrame)
		end
	end)
end)