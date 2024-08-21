local text = script.Parent

local plrGui = game:GetService("Players").LocalPlayer.PlayerGui

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

text.MouseButton1Down:Connect(function(x: number, y: number)
	script.Parent.Parent.Parent.Parent:Destroy()
	local Warn = require(game.ReplicatedStorage:WaitForChild("WarningUI"))
	Warn.NewWarning("Are you sure you want to dismiss that?", plrGui)
end)