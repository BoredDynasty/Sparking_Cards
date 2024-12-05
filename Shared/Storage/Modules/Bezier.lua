-- BezierModule.lua
-- This module generates Bézier curves with support for multiple control points.

local BezierModule = {}

-- Function to compute a point on a Bézier curve given t (0 <= t <= 1) and control points.
local function computeBezierPoint(t, controlPoints)
	local n = #controlPoints
	local tempPoints = {}

	-- Copy the control points to a temporary array
	for i = 1, n do
		tempPoints[i] = controlPoints[i]
	end

	-- Perform the de Casteljau's algorithm
	for r = 1, n - 1 do
		for i = 1, n - r do
			tempPoints[i] = tempPoints[i] * (1 - t) + tempPoints[i + 1] * t
		end
	end

	return tempPoints[1]
end

-- Function to generate points along the Bézier curve
function BezierModule.GenerateCurve(controlPoints, segmentCount)
	assert(#controlPoints >= 2, "At least two control points are required.")
	local curvePoints = {}

	-- Generate points along the curve
	for i = 0, segmentCount do
		local t = i / segmentCount
		table.insert(curvePoints, computeBezierPoint(t, controlPoints))
	end

	return curvePoints
end

-- Function to visualize the Bézier curve on a part
function BezierModule.VisualizeCurve(part, controlPoints, segmentCount)
	local curvePoints = BezierModule.GenerateCurve(controlPoints, segmentCount)
	local adornmentFolder = Instance.new("Folder")
	adornmentFolder.Name = "BezierCurveVisualization"
	adornmentFolder.Parent = part

	-- Draw parts or adornments at the curve points
	for _, point in ipairs(curvePoints) do
		local sphere = Instance.new("Part")
		sphere.Shape = Enum.PartType.Ball
		sphere.Size = Vector3.new(0.2, 0.2, 0.2)
		sphere.Position = point
		sphere.Anchored = true
		sphere.CanCollide = false
		sphere.Parent = adornmentFolder
	end
end

return BezierModule
