--!strict
local ReplicateStorage = game.ReplicatedStorage

local tweenDebounce = false

local ChangeTurnsDisplay = script.Parent.ChangeTurns
local MainFrame = script.Parent.Frame

local sound = script.Sound

local Player = game.Players
local LocalPlayer = Player.LocalPlayer

local TweeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Script for tweening the transparency of a GUI object

ChangeTurnsDisplay.MouseEnter:Connect(function()
	sound:Play()
	ChangeTurnsDisplay:TweenPosition(UDim2.new(0.471, 0, 0.916, 0), TweeInfo)
end)

ChangeTurnsDisplay.MouseLeave:Connect(function()
	ChangeTurnsDisplay:TweenPosition(UDim2.new(0.471, 0, 0.926, 0), TweeInfo)
end)

MainFrame.MouseEnter:Connect(function()
	sound:Play()
	MainFrame:TweenPosition(UDim2.new(0.017, 0, 0.916, 0), TweeInfo)
end)

MainFrame.MouseLeave:Connect(function()
	MainFrame:TweenPosition(UDim2.new(0.017, 0, 0.926, 0), TweeInfo)
end)

-- Start the tween
--[[
function mouseLeaveHover()
	task.wait(2)
	if tweenDebounce then return end
	tweenDebounce = true

	if ChangeTurnsDisplay.Visible then
		guiObject = HoverButton
		tween:Play()
		task.wait(0.2)
		ChangeTurnsDisplay.Visible = false
		tweenDebounce = false
	end
end

function mouseEnterHover()
	task.wait(5)
	if tweenDebounce then return end
	tweenDebounce = true

	if ChangeTurnsDisplay.Visible then
		guiObject = HoverButton
		tween2:Play()
		task.wait(0.2)
		ChangeTurnsDisplay.Visible = true
		tweenDebounce = false
	end
end

local MainFrame_Before_Pos = UDim2.new(0.017, 0,0.926, 0)

local Health_Before = UDim2.new(0.017, 0,0.875, 0)
local Health_After = UDim2.new(0.258, 0,0.875, 0)

-- Tweening --
--[[
-- Whenever EnemyTurn is fired make ChangeTurnsDisplay Tween to CTD_Before_Pos. 
HoverButton.MouseLeave:Connect(function()
	if tweenDebounce then return end
	tweenDebounce = true

	if ChangeTurnsDisplay.Visible then
		ChangeTurnsDisplay:TweenPosition(UDim2.new(0.471, 0,0.946, 0), "In", "Quint", 0.2, true)
		task.wait(0.2)
		ChangeTurnsDisplay.Visible = false
		tweenDebounce = false
	end
end)
-- Whenever HeroTurn is fired make ChangeTurnsDisplay Tween to CTD_Before_Pos. 
HoverButton.MouseEnter:Connect(function()
	if tweenDebounce then return end
	tweenDebounce = true

	if ChangeTurnsDisplay.Visible == false then
		ChangeTurnsDisplay:TweenPosition(UDim2.new(0.471, 0,0.926, 0), "In", "Quint", 0.2, true)
		task.wait(0.2)
		ChangeTurnsDisplay.Visible = true
		tweenDebounce = false
	end
end)

-- Make HealthDisplay display the PlayerHealth. Update it every 1 second. 

--]]
