--!strict
local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local ScreenUI = game.StarterGui
local Frame
local Text = Frame.Text

local function cleanup(clone)
	task.wait(5)
	TweenService:Create(clone.Frame, TweenInfo.new(1), { Size = UDim2.new(0, 0, 0.065, 0) })
	task.wait(0.55)
	TweenService:Create(clone.Frame, TweenInfo.new(1), { Position = UDim2.new(0.22, 0, 2, 0) })
	task.wait(1)
	clone:Destroy()
end

local function writeText(text, textlabel)
	local DisplayText = text

	for i = 1, #DisplayText do
		textlabel.Text = string.sub(DisplayText, 1, i)
		task.wait(0.05)
	end
end

module.NewNotification = function(player: Player, text: string)
	local clone = ScreenUI:Clone()
	clone.Parent = player.PlayerGui
	clone.Frame.Size = UDim2.new(0, 0, 0.065, 0)

	TweenService:Create(clone.Frame, TweenInfo.new(0.5), { Position = UDim2.new(0.39, 0, 0.9, 0) })
	task.wait(0.55)
	TweenService:Create(clone.Frame, TweenInfo.new(1), { Size = UDim2.new(0.22, 0, 0.065, 0) })

	writeText(text, clone.Frame.Text)

	local waitTime: number
	for i = 0.2, #text do
		waitTime += i
	end

	task.wait(waitTime)
	cleanup(clone)
end

return module
