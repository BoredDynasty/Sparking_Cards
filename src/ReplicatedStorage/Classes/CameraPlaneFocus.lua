local focusCamera = {}

function focusCamera:FocusOnPlane(cframe, size)
	local camera = workspace.CurrentCamera
	
	local verticalFOV = math.rad(camera.FieldOfView)
	local horizontalFOV = 2 * math.atan2(math.tan(verticalFOV / 2) * camera.ViewportSize.X, camera.ViewportSize.Y)
	
	local horizontalDist = size.X / (2 * math.tan(horizontalFOV / 2))
	local verticalDist = size.Y / (2 * math.tan(verticalFOV / 2))
	local dist = math.max(horizontalDist, verticalDist)
	
	return cframe * CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.pi, 0)
end

function focusCamera:FocusOnPart(part)
	return focusCamera:FocusOnPlane(part.CFrame * CFrame.new(0, 0, -part.Size.Z / 2), part.Size)
end

return focusCamera
