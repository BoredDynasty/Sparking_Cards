--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

local Tooltip = script.Parent.Tooltip

local Mouse = game.Players.LocalPlayer:GetMouse()
local Offset = UDim2.new(0.015, 0, -0.01, 0)

--[[
if GlobalSettings.IsStudio == false then
	script.Parent.Letter.Visible = true
	local letter = [[
	Hey, funnily enough, this game is going to take <i>some time</i> to create. Please wait patiently because I have no help right now. Ill try my best to make a little more updates here and there. If you have any <i>Grand Ideas</i> please tell me! This development is going harder than I expected. Be patient! btw im not cancelling the project <i>ehehehe~!</i><br> </br><br>Thanks!</br> <br>OfficialDynasty</br>
	game.Loaded:Wait()
	UIEffectsClass.TypewriterEffect(letter, script.Parent.Letter.Text)
else
	return
end
--]]

script.Parent.Letter.Visible = true
local letter = [[
	Hey, funnily enough, this game is going to take <i>some time</i> to create. Please wait patiently because I have no help right now. Ill try my best to make a little more updates here and there. If you have any <i>Grand Ideas</i> please tell me! This development is going harder than I expected. Be patient! btw im not cancelling the project <i>ehehehe~!</i><br> </br><br>Thanks!</br> <br>OfficialDynasty</br>
	]]
game.Loaded:Wait()
UIEffectsClass.TypewriterEffect(letter, script.Parent.Letter.Text)

Mouse.Move:Connect(function()
	if Mouse.Target then
		if Mouse.Target:FindFirstChild("Tooltip") and Mouse.Target:FindFirstChild("Tooltip").Value == true then
			Tooltip.NameUI.Text = Mouse.Target.Tooltip:FindFirstChild("Name").Value
			Tooltip.DescUI.Text = Mouse.Target.Tooltip:FindFirstChild("Desc").Value
			Tooltip.DescUI.RichText = false
			Tooltip.NameUI.RichText = false
			--Mouse.Icon = "rbxassetid://9563790132"

			local RichBool = Mouse.Target.Tooltip:FindFirstChildOfClass("BoolValue")
			if RichBool then
				Tooltip.DescUI.RichText = true
				Tooltip.NameUI.RichText = true
			end
			Tooltip.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y) + Offset
			script.Parent.Tooltip.Visible = true
		else
			script.Parent.Tooltip.Visible = false
			Tooltip.DescUI.RichText = false
			Tooltip.NameUI.RichText = false
			--Mouse.Icon = "rbxassetid://9563784745"
		end
	else
		Tooltip.DescUI.RichText = false
		Tooltip.NameUI.RichText = false
		script.Parent.Tooltip.Visible = false
		--Mouse.Icon = "rbxassetid://9563784745"
	end
end)
