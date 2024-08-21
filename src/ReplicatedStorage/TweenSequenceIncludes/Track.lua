local TweenUtilities = require(script.Parent.TweenUtilities)
local createSignal = require(script.Parent.createSignal)

local Track = {}
Track.__index = Track

local function checkNil(val)
	if val == nil then
		error("Expected ':', not '.', when calling this function.")
	end
end

function Track.new(root, tweenTable, module)
	local self = {
		playing = false,
		DonePlaying = Instance.new("BindableEvent"),
		tweenUtils = TweenUtilities.new(root, tweenTable, module),
	}
	self.Completed = self.DonePlaying.Event
	setmetatable(self, Track)
	return self
end

function Track:SetOrigin(origin)
	if origin == nil or typeof(origin) == "CFrame" then
		self.tweenUtils:SetOrigin(origin)
	else
		self.tweenUtils:SetOrigin(CFrame.new(origin))
	end
end

function Track:Play()
	checkNil(self)
	self.playing = true
	self.tweenUtils:ResetValues()
	self.tweenUtils:PlayTweens(function()
		self:OnDonePlaying()
	end)
end

function Track:Loop(cycles)
	checkNil(self)
	if cycles ~= nil and cycles == 0 then
		self:OnDonePlaying()
		return
	end
	self.playing = true
	self.tweenUtils:ResetValues()
	local finished = createSignal()
	local disconnect = finished:subscribe(function()
		if self.playing then
			self:Loop(cycles and cycles - 1)
		else
			self:OnDonePlaying()
		end
	end)
	self.tweenUtils:PlayTweens(function()
		if finished then
			finished:fire()
			disconnect()
			finished = nil
		end
	end)
end

function Track:Stop()
	checkNil(self)
	self.playing = false
	self.tweenUtils:PauseTweens()
	self.tweenUtils:ResetValues()
end

function Track:OnDonePlaying()
	self.DonePlaying:Fire()
end

return Track
