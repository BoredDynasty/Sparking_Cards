local clickDetect = script.Parent.ClickDetector
local player = game.Players

local part = script.Parent

clickDetect.MouseClick:Connect(function(playerWhoClicked: Player) 
	playerWhoClicked.Character:BreakJoints()
end)
