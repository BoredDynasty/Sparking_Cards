local button = script.Parent
local buttonTransp = button.BackgroundTransparency

local stroke = button.UIStroke
local strokeTransp = stroke.Transparency

local tip = script.Parent.Control

local tween = game:GetService("TweenService")
local tInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- Make the buttonTransp 0 when the players mouse hovers over button.
button.MouseEnter:Connect(function()
	tween:Create(button, tInfo, {BackgroundTransparency = 0}):Play()
	tween:Create(stroke, tInfo, {Transparency = 0}):Play()
	tween:Create(tip, tInfo, {TextTransparency = 0.5}):Play()
end)

button.MouseLeave:Connect(function()
	tween:Create(button, tInfo, {BackgroundTransparency = 1}):Play()
	tween:Create(stroke, tInfo, {Transparency = 1}):Play()
	tween:Create(tip, tInfo, {TextTransparency = 1}):Play()
end)