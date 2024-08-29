--!strict
local Class = {}
Class.__index = Class

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathClass = require(ReplicatedStorage.Classes.MathClass)

Class.IntermissionTime = MathClass.Random(20, 30) -- Randomized 20 , 30
Class.MaxTime = 240
Class.MaxChoosingTime = 20
Class.MatchContinued = false
Class.ValidCards = { Fire = 9, Frost = 5, Plasma = 12, Water = 4 }
Class.IsPrivateServer = false

Class.PlayerSettings =
	{ A = "Light Mode", B = "Dark Mode", C = "Hide Players", D = "Notifications", E = "Remove All Light Beams" }

--[=[
    Sets the Default Settings

    @param MaxTime number -- The Max Round time
    @param MaxChoosingTime number -- The Max time the player has to choose a card
]=]
function Class.SetDefaultSettings(MaxTime: number, MaxChoosingTime: number) -- Sets The Default Values
	Class.MaxChoosingTime = MaxChoosingTime
	Class.MaxTime = MaxTime
end

--[=[
    Restores Default Settings

    @param MaxTime number -- The Max Round time is now 240
    @param MaxChoosingTime number -- The Max time the player has to choose a card is now 20
]=]
function Class.RestoreDefaultSettings()
	Class.MaxTime = 240
	Class.MaxChoosingTime = 20
end

function Class.GrabPrivateServer() -- Returns true if the game is running a private server
	if game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0 then
		Players.PlayerAdded:Connect(function(player)
			if player.UserId == game.PrivateServerOwnerId then
				Class.IsPrivateServer = true
				return true
			else
				Class.IsPrivateServer = false
				return false
			end
		end)
	end
end

return Class
