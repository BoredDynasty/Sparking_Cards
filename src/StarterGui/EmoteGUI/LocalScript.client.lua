--!strict

local frame = script.Parent.HolderFrame
local Keycode = Enum.KeyCode.Tab

local UserInputService = game:GetService("UserInputService")

local function openFrame()
	local TweenService = game:GetService("TweenService")
	local TweenParams = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	frame.Visible = true
	TweenService:Create(frame, TweenParams, { Position = UDim2.new(0.5, 0, 0.5, 0) })
end

local function closeFrame()
	local TweenService = game:GetService("TweenService")
	local TweenParams = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	TweenService:Create(frame, TweenParams, { Position = UDim2.new(0.5, 0, 0.6, 0) }):Play()
	task.wait(0.195)
	frame.Visible = false
end

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
	end

	if input.KeyCode == Keycode then
		openFrame()
	end
end)

UserInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
	end

	if input.KeyCode == Keycode then
		closeFrame()
	end
end)
