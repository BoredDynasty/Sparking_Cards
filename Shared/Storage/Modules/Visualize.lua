--!nonstrict

-- Visualize.lua

local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")

local Trajectory = require(ServerStorage.Modules.Trajectory)

return function(targetPosition, peakHeight, part: BasePart)
	local startPosition = part.Position
	local velocity = Trajectory(startPosition, targetPosition, peakHeight)

	-- Ensure the part is anchored and has a BodyVelocity for smooth movement
	part.Anchored = false
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5) -- Large enough to overcome gravity
	bodyVelocity.Velocity = velocity
	bodyVelocity.Parent = part

	Debris:AddItem(bodyVelocity, 2)
end
