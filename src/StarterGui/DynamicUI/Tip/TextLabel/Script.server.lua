--!strict
local text = script.Parent

local RunService = game:GetService("RunService")

local tween = game:GetService("TweenService")
local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

if RunService:IsStudio() then
	text.Text = "STUDIO  MODE   [ TESTING ]"
end

text.Text = "TESTING  MODE   [ DEFAULT ]"

if RunService:IsClient() then
	text.Text = "CLIENT  MODE   [ DEFAULT ]"
end

if RunService:IsServer() then
	text.Text = "SERVER  MODE   [ SERVER ]"
end

task.spawn(function()
	tween:Create(text, TInfo, { TextTransparency = 0.8 }):Play()
	task.wait(0.4)
	tween:Create(text, TInfo, { TextTransparency = 0 }):Play()
	task.wait(0.4)
end)
