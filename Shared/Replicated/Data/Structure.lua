return {
	["BaseValue"] = 4,
	["Types"] = {
		["Fire"] = 1, -- GetAttribute()
		["Frost"] = 1,
		["Plasma"] = 1,
		["Water"] = 1,
	},
	["Abilities"] = {
		["Charge"] = {
			["Healing"] = 10,
			["Unlocked"] = false,
		},
		["Ultimate"] = {
			["Damage"] = 95,
			["Healing"] = false,
			["Unlocked"] = false,
		},
		["Fusion Coil"] = {
			["Damage"] = 1005,
			["Healing"] = false,
			["Unlocked"] = false,
		},
		["Supernatural Radiation"] = {
			["Damage"] = math.huge, -- teehee
			["Healing"] = false,
			["Unlocked"] = false,
		},
	},
}
