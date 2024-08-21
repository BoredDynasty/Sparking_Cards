local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local mustHaveTrackError = [[Center Instance must have a CFrame track to use SetOrigin.
	Tween Name: %s
	Instance: %s
	Root: %s]]

local function Split(str)
	local names = {}

	for name in str:gmatch("[^.]+") do
		table.insert(names, name)
	end

	return names
end

local function FindFirstDescendant(root, path)
	local names = Split(path)
	if #names == 1 then
		return root
	else
		local current = root
		for i = 2, #names do
			current = current:FindFirstChild(names[i])
			if current == nil then
				return nil
			end
		end
		return current
	end
end

local function VisitAllInstances(root, tweenTable, func)
	for path, props in pairs(tweenTable) do
		local instance = FindFirstDescendant(root, path)
		if instance == nil then
			error("Could not find descendant along path:", path)
		end
		func(instance, props, path)
	end
end

local function ApplyOrigin(prop, value, initialFrame, origin)
	if prop == "CFrame" then
		return origin * initialFrame * value
	elseif prop == "Position" then
		return (origin * initialFrame * CFrame.new(value)).Position
	elseif prop == "Orientation" then
		local frame = origin * initialFrame * CFrame.fromOrientation(
			math.rad(value.X),
			math.rad(value.Y),
			math.rad(value.Z)
		)
		local x, y, z = frame:ToOrientation()
		return Vector3.new(math.deg(x), math.deg(y), math.deg(z))
	end
	return nil
end

local TweenUtilities = {}
TweenUtilities.__index = TweenUtilities

function TweenUtilities.new(root, tweenTable, module)
	local self = {
		running = false,
		root = root,
		tweenTable = tweenTable,
		module = module or {
			Name = "<PLUGIN OUT OF DATE, PLEASE UPDATE>",
		},
		origin = nil,
		connections = {},
	}
	setmetatable(self, TweenUtilities)
	self.tweens = self:BuildTweens()

	return self
end

local function relativePath(root, instance)
	local path = instance.Name
	while instance ~= root and instance ~= nil do
		instance = instance.Parent
		if instance == root then
			path = "Root." .. path
		elseif instance ~= nil then
			path = instance.Name .. "." .. path
		else
			return nil
		end
	end
	return path
end

-- Builds a set of runnable Tweens from a table of instances and values
function TweenUtilities:BuildTweens()
	local tweens = {}
	local origin = self.origin
	local root = self.root
	local tweenTable = self.tweenTable

	local initialFrame
	local initialPos, initialRot, originPos, originRot
	local center
	if origin ~= nil then
		if root:IsA("Model") then
			center = root.PrimaryPart
			if center == nil then
				error("Root Model must have a PrimaryPart to use SetOrigin.")
			end
		elseif root:IsA("BasePart") then
			center = root
		else
			error("Root must be a BasePart or Model to use SetOrigin.")
		end
		
		local path = relativePath(root, center)
		local rootTrack = tweenTable[path]
		assert(rootTrack, string.format(mustHaveTrackError, self.module.Name, path, root:GetFullName()))
		assert(rootTrack.CFrame, string.format(mustHaveTrackError, self.module.Name, path, root:GetFullName()))

		initialFrame = rootTrack.CFrame.InitialValue:inverse()
		initialPos = initialFrame.Position
		initialRot = initialFrame - initialPos
		originPos = origin.Position
		originRot = origin - originPos
	end

	VisitAllInstances(root, tweenTable, function(instance, props, path)
		local tween = {}
		for prop, values in pairs(props) do
			local track = {}

			if origin and instance:IsA("BasePart") then
				local newValue = ApplyOrigin(prop, values.InitialValue, initialFrame, origin)
				if newValue then
					values.InitialValue = newValue
				end
			end

			local keyframes = values.Keyframes
			local lastTime = 0
			
			if #keyframes > 0 then
				for _, keyframe in ipairs(keyframes) do
					if origin and instance:IsA("BasePart") then
						local newValue = ApplyOrigin(prop, keyframe.Value, initialFrame, origin)
						if newValue then
							keyframe.Value = newValue
						end
					end

					local tweenInfo = TweenInfo.new(keyframe.Time - lastTime,
						keyframe.EasingStyle,keyframe.EasingDirection, 0, false, 0)
					local propTable = {
						[prop] = keyframe.Value
					}
					local tween = TweenService:Create(instance, tweenInfo, propTable)
					table.insert(track, {
						Tween = tween,
						DelayTime = lastTime,
					})
					lastTime = keyframe.Time
				end

				table.sort(track, function(first, second)
					return first.DelayTime < second.DelayTime
				end)
				tween[prop] = track
			end
		end
		
		tweens[path] = tween
	end)
	
	return tweens
end

function TweenUtilities:ResetValues()
	if self.origin then
		if self.root:IsA("Model") then
			if self.root.PrimaryPart == nil then
				error("Root Model must have a PrimaryPart to use SetOrigin.")
			end
			self.root:SetPrimaryPartCFrame(self.origin)
		elseif self.root:IsA("BasePart") then
			self.root.CFrame = self.origin
		else
			error("Root must be a BasePart or Model to use SetOrigin.")
		end
	end

	VisitAllInstances(self.root, self.tweenTable, function(instance, props)
		for prop, values in pairs(props) do
			local initialValue = values.InitialValue
			instance[prop] = initialValue
		end
	end)
end

function TweenUtilities:SetOrigin(origin)
	if self.running then
		error("Cannot SetOrigin while the animation is running.")
	end
	self.origin = origin
	self.tweens = self:BuildTweens()
end

function TweenUtilities:PlayTweens(callback)
	if self.running then
		self:PauseTweens()
	end
	self.running = true
	self.tweens = self:BuildTweens()

	local root = self.root
	local tweenTable = self.tweenTable
	
	self.completed = {}
	VisitAllInstances(root, tweenTable, function(instance, props, path)
		for trackName, _ in pairs(self.tweens[path]) do
			self.completed[path .. trackName] = false
		end
	end)
	
	local finally = function(path, trackName)
		self.completed[path .. trackName] = true
		for _, finished in pairs(self.completed) do
			if not finished then
				return
			end
		end
		callback()
	end
	
	if #self.connections > 0 then
		for _, connection in pairs(self.connections) do
			connection:Disconnect()
		end
		self.connections = {}
	end

	VisitAllInstances(root, tweenTable, function(instance, props, path)
		local function tweenChain(track, trackName, index, finally)
			local tween = track[index].Tween
			local key = path .. trackName .. tostring(index)
			self.connections[key] = tween.Completed:Connect(function(playbackState)
				if playbackState == Enum.PlaybackState.Completed then
					if self.connections[key] then
						self.connections[key]:Disconnect()
						self.connections[key] = nil
					end
					if self.running then
						if #track > index then
							tweenChain(track, trackName, index + 1, finally)
						else
							finally(path, trackName)
						end
					end
				end
			end)
			tween:Play()
		end

		for trackName, track in pairs(self.tweens[path]) do
			tweenChain(track, trackName, 1, finally)
		end
	end)
end

function TweenUtilities:PauseTweens()
	self.running = false
	if #self.connections > 0 then
		for _, connection in pairs(self.connections) do
			connection:Disconnect()
		end
		self.connections = {}
	end
	for _, tween in pairs(self.tweens) do
		for _, track in pairs(tween) do
			for _, props in pairs(track) do
				local tween = props.Tween
				tween:Cancel()
			end
		end
	end
end

return TweenUtilities
