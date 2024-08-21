local text = script.Parent

local tween = game:GetService("TweenService")
local TInfo = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)
while true do
	tween:Create(text, TInfo, {ImageTransparency = 0.8}):Play()
	wait(0.4)
	tween:Create(text, TInfo, {ImageTransparency = 0}):Play()
	wait(0.4)
end