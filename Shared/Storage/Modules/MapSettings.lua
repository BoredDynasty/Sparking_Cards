local Settings = {}

local ServerStorage = game:GetService("ServerStorage")

local mapSettings = {
	["Classic"] = {
		["Lighting"] = {
			["ClockTime"] = 8,
			["Brightness"] = 2,
			["Ambient"] = Color3.fromRGB(80, 80, 80),
			["Density"] = 0.4,
			["Offset"] = 0.131,
			["Glare"] = 0.1,
			["Saturation"] = 0.5,
		},
		["Accesibility"] = {
			["Highlights"] = true,
		},
		["Model"] = ServerStorage.Maps.Crossroad,
	},
}

function Settings.newMap(mapName): {}?
	return mapSettings[mapName]
end

function Settings.retreiveRandom()
	return mapSettings[math.random(1, #mapSettings)]
end

function Settings.__rawget()
	return mapSettings
end

return Settings
