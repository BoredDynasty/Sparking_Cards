local clickDetect = script.Parent.ClickDetector
local players = game.Players

clickDetect.MouseClick:Connect(function(playerWhoClicked: Player)  
--[[	local character = playerWhoClicked.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.RootPart.CFrame = CFrame.new(Vector3.new(100.001, 10.001, 100.001))
		end
	end
	--]]
	if playerWhoClicked.Character then
		playerWhoClicked.Character:PivotTo(workspace.Subway.SpawnLocation.Part.CFrame)
	end
end)