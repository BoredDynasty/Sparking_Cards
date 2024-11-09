--!strict

--[=[
	@class Global

	A Module Config for the game.
]=]
local Global = {}
Global.__index = Global

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

Global.IntermissionTime = math.random(20, 30) -- Randomized 20 , 30
Global.MaxTime = 240 -- max gametime
Global.MaxChoosingTime = 20
Global.MatchContinued = false
Global.ValidCards = { Fire = 9, Frost = 5, Plasma = 12, Water = 4 }
Global.IsPrivateServer = false
Global.IsStudio = false
Global.DefaultAward = 24 -- default add cards

Global.StartingCardsValue = 5
Global.StartingRankValue = "Bronze I"
Global.StartingMultiplierValue = "Untitled"
Global.StartingAbilityValue = "Charge"
Global.StartingExperienceValue = 0

Global.PlayerSettings =
	{ A = "Light Mode", B = "Dark Mode", C = "Hide Players", D = "Notifications", E = "Remove All Light Beams" }
Global.Characters = {
	["Edo"] = {
		type = "non_main",
		attribute = "side_character",
		tag = "edo_character",
	},
	["Obsidian"] = {
		type = "shop",
		attribute = "shop_person",
		tag = "obsidian_npc",
	},
	["Coach Mr. G"] = {
		type = "main",
		attribute = "coach_main",
		tag = "mr_g_character",
	},
}
Global.ValidWeapons = {
	["Charge"] = {
		type = "base",
	},
	["Ultimate"] = {
		type = "super",
	},
	["Fusion Coil"] = {
		type = "ultimate",
	},
	["Supernatural Radiation"] = {
		type = "super",
	},
}
Global.WinMessages = { "Well now, you did Great~! ", "You can do better than that right?", "OMG~!", "Ehehehehe~!" }
Global.WinLines = { "ALRIGHT~!", "WOWIE!" }
Global.CustomLines = { "Well now, let's get going!", "Heya.", "Heheh..." }
function Global.SetDefaultSettings(MaxTime: number, MaxChoosingTime: number) -- Sets The Default Values
	Global.MaxChoosingTime = MaxChoosingTime
	Global.MaxTime = MaxTime
end
function Global.RestoreDefaultSettings()
	Global.MaxTime = 240
	Global.MaxChoosingTime = 20
end
function Global.GrabPrivateServer()
	if game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0 then
		Players.PlayerAdded:Connect(function(player)
			if player.UserId == game.PrivateServerOwnerId then
				Global.IsPrivateServer = true
			else
				Global.IsPrivateServer = false
			end
		end)
	end
end

if RunService:IsStudio() then
	Global.IsStudio = true
end

return Global
