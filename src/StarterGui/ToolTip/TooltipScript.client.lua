--!strict
--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

UIEffectsClass.Constructor()

local Tooltip = script.Parent.Tooltip

local Mouse = game.Players.LocalPlayer:GetMouse()
local Offset = UDim2.new(0.015, 0, -0.01, 0)

local function onMouseMove()
	if Mouse.Target:HasTag("ToolTip") then
		local text = Mouse.Target:GetAttribute("ToolTip")
		UIEffectsClass.TypewriterEffect(text, Tooltip.DescUI, 0.02)
	end
end

Mouse.Move:Connect(onMouseMove)
