--!nocheck
local Class = {}
Class = Class.__index
Class.MaxTime = 240
Class.MaxChoosingTime = 20
Class.MatchContinued = false
Class.ValidCards = {}

table.insert(Class.ValidCards, "Fire", 9)
table.insert(Class.ValidCards, "Frost", 5)
table.insert(Class.ValidCards, "Plasma", 12)
table.insert(Class.ValidCards, "Water", 4)

function Class.SetDefaultSettings(MaxTime: number, MaxChoosingTime: number)
	Class.MaxChoosingTime = MaxChoosingTime
	Class.MaxTime = MaxTime
end

function Class.RestoreDefaultSettings()
	Class.MaxTime = 240
	Class.MaxChoosingTime = 20
end

return Class
