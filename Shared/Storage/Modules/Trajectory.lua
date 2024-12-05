--!nonstrict

-- Trajectory.lua

local gravity = workspace.Gravity -- Default is 196.2 in Roblox

-- Function to calculate the velocity
return function(startPos, targetPos, peak)
	local displacement = targetPos - startPos
	local horizontalDisplacement = Vector3.new(displacement.X, 0, displacement.Z)
	-- local horizontalDistance = horizontalDisplacement.Magnitude

	-- Calculate the time of flight based on peak height and gravity
	local timeToPeak = math.sqrt(2 * peak / gravity)
	local totalTime = timeToPeak * 2

	-- Calculate vertical velocity (v = sqrt(2gh))
	local verticalVelocity = math.sqrt(2 * gravity * peak)

	-- Calculate horizontal velocity (d = vt)
	local horizontalVelocity = horizontalDisplacement / totalTime

	-- Return the final velocity vector
	return horizontalVelocity + Vector3.new(0, verticalVelocity, 0)
end
