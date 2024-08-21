--[[local b = script.Parent.Parent.EndSequence:TweenPosition(UDim2.new(0,0,0,0), "InOut", "Quad", 3, true)
local frame = script.Parent.Parent

function endse()
	script.Parent.Parent.EndSequence:TweenPosition(UDim2.new(0,0,0,0), "InOut", "Quad", 3, true)
	wait(3)
	script.Parent.Parent.EndSequence:TweenPosition(UDim2.new(-1,0,0,0), "InOut", "Quad", 3, true)
end

script.Parent.MouseButton2Click:Connect(function()
	endse()
end)
--]]

local button = script.Parent

-- wHen a player joins, the button cannot be interacted in 15 seconds
local function onPlayerAdded(player)
	warn("Wait 15 Seconds for PlayButton to become Active!")
	button.Interactable = false
	task.wait(15)
	warn("Play Button is now Active!")
	button.Interactable = true
end

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(onPlayerAdded)