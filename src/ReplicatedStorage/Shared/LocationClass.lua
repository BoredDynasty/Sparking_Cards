--!strict
local Class = {}
Class.__index = Class

function Class.new()
	local self = setmetatable({}, Class)

	return self
end

function Class.PlayerEnteredArea(areaName: string, player: Player)
    
end

return Class
