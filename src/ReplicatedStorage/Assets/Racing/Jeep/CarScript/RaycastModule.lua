local module = {}

function module.new(startPosition, startDirection)
	local maxDistance = startDirection.magnitude
	local direction = startDirection.unit
	local lastPosition = startPosition
	local distance = 0
	local ignore = {}
	
	local hit, position, normal
	
	repeat
		local ray = Ray.new(lastPosition, direction * (maxDistance - distance))
		hit, position, normal = game.Workspace:FindPartOnRayWithIgnoreList(ray, ignore, false, true)
		if hit then
			if not hit.CanCollide then
				table.insert(ignore, hit)
			end
		end
		distance = (startPosition - position).magnitude
		lastPosition = position
	until distance >= maxDistance - 0.1 or (hit and hit.CanCollide)
	return hit, position, normal
end

return module
