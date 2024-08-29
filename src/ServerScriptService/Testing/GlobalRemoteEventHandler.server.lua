--!strict
local Replicated = game.ReplicatedStorage

--------------- Local Remotes

local DrawCardsHide = Replicated.RemoteEvents.SpecificUIHide.DrawCardsHidden
local LetterboxRemote = Replicated.RemoteEvents.SpecificUIHide.Letterbox
local NotificationRemote = Replicated.RemoteEvents.CreateNotification

local Inmerse = require(Replicated.Classes.Inmerse)

---------------------- Seperate Controls

task.wait(1)
Inmerse.Setup()
