--[[
    Scripter: Nyxaris
    Version: 1.0.2
]]

local SettingsManager = {}

--// Main Settings
SettingsManager.Settings = {
	groupRanks = {
		groupID = nil,
		enableGroupRanks = false
	},
	leaderstats = {
		folderName = "leaderstats",
		enable = false
	}
}

--// Group ranks
SettingsManager.GroupRanks = {
	[0] = {
		icon = "rbxassetid://0"
	},
	[1] = {
		icon = "rbxassetid://0"
	}
}

return SettingsManager