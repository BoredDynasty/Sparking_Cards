--!strict
local indicator = script.Parent

local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

task.spawn(function()
	TweenService:Create(indicator, TweenParams, { ImageColor3 = Color3.fromHex("#55ff7f") }):Play()
	task.wait(1.2)
	TweenService:Create(indicator, TweenParams, { ImageColor3 = Color3.fromHex("#FFFFFF") }):Play()
end)
