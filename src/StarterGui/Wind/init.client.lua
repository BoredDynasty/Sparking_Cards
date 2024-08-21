local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local WIND_DIRECTION = script.Parent.Wind:WaitForChild("Direction").Value
local WIND_SPEED = script.Parent.Wind:WaitForChild("Speed").Value
local WIND_POWER = script.Parent.Wind:WaitForChild("Power").Value
local WindLines = require(script.WindLines)

WindLines:Init({
	Direction = WIND_DIRECTION;
	Speed = WIND_SPEED;
	Lifetime = 1.5;
	SpawnRate = 15;
})

