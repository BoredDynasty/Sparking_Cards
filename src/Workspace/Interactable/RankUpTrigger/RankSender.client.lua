local replicated = game.ReplicatedStorage

local waitTime = script.Parent:GetAttribute("DissapearTime")
local isLetterBox = script.Parent:GetAttribute("isLetterBox")

script.Parent.ClickDetector.MouseClick:Connect(function(playerWhoClicked: Player)
	replicated.RemoteEvents.RankUp:FireAllClients(waitTime, isLetterBox)
	print("Sent FireClient Rankup")
end)
