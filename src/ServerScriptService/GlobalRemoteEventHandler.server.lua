--!strict
local Replicated = game.ReplicatedStorage

--------------- Local Remotes

local DrawCardsHide = Replicated.RemoteEvents.SpecificUIHide.DrawCardsHidden
local LetterboxRemote = Replicated.RemoteEvents.SpecificUIHide.Letterbox
local NotificationRemote = Replicated.RemoteEvents.CreateNotification
local Warning = require(Replicated.WarningUI)
local Inmerse = require(Replicated.Inmerse)
---------------------- Seperate Controls

local UI = game.StarterGui.BattleUI.Draw.Notis

function HideDrawCardsButton()
	DrawCardsHide:FireAllClients()
end

function IncrementNotification()
	-- fires the notification to the client to increment the notification count
	NotificationRemote:FireAllClients()
end

-- make a loop to check the player's inventory for the notification items
while true do
	wait(10)
	IncrementNotification()
end

while true do
	wait(10)
	HideDrawCardsButton()
end

workspace.SpawnLocation.ClickDetector.MouseClick:Connect(function(playerWhoClicked: Player)
	LetterboxRemote:FireClient()
	print("LetterboxRemote using :FireClient")
end)

local WarningText = "This is a test! [Server-Side]"

task.wait(40)
Warning.NewWarning(WarningText, game.Players.LocalPlayer.PlayerGui)
Inmerse.Setup()
