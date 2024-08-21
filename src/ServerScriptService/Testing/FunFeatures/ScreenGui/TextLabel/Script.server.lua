local text = script.Parent

local RunService = game:GetService("RunService")

local tween = game:GetService("TweenService")
local TInfo = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

while true do
	tween:Create(text, TInfo, {TextTransparency = 0.2}):Play()
	wait(0.4)
	tween:Create(text, TInfo, {TextTransparency = 0}):Play()
	wait(0.4)
end