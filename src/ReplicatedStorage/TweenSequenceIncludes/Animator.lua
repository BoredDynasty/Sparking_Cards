--[[
	TweenSequence Editor Animator
]]

local TweenSequenceUtils = script.Parent
local Track = require(TweenSequenceUtils.Track)

local Animator = {}

function Animator.new(tweens, root)
	local newAnimator = {}

	for _, tween in pairs(tweens:GetChildren()) do
		local tweenTable = require(tween)
		newAnimator[tween.Name] = Track.new(root, tweenTable, tween)
	end
	
	function newAnimator:SetOrigin(origin)
		for _, animation in pairs(newAnimator) do
			if type(animation) == "table" then
				animation:SetOrigin(origin)
			end
		end
	end

	function newAnimator.StopAll()
		for _, animation in pairs(newAnimator) do
			if type(animation) == "table" then
				animation:Stop()
			end
		end
	end

	return newAnimator
end

return Animator
