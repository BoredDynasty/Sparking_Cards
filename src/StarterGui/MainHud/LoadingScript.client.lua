--!strict
local mainFrame = script.Parent.Frame
local LoadingScreen = script.Parent.Loading

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PlayButton = LoadingScreen:WaitForChild("PlayButton")

local Assets = game:GetDescendants()

local tweenservice = game.TweenService
local TInfoParams = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
--[[
for i = 1, #Assets do
	local Asset = Assets[i]
	-- local Percentage = math.round(i/#Assets * 100)
	ContentProvider:PreloadAsync({Asset})
	if i % 5 == 0 then
		wait()
	end

	if i == #Assets then
		wait(1)
	end
end
--]]

task.wait(25)
LoadingScreen.PlayButton.Visible = true

LoadingScreen.PlayButton.MouseButton1Down:Connect(function()
	tweenservice:Create(LoadingScreen.PlayButton, TInfoParams, { Size = UDim2.new(0.073, 0, 0.05, 0) })
	tweenservice:Create(LoadingScreen.PlayButton, TInfoParams, { UDim2.new(0.391, 0, 0.526, 0) })
	tweenservice:Create(LoadingScreen, TInfoParams, { BackgroundTransparency = 1 }):Play()
	tweenservice:Create(LoadingScreen.ImageLabel, TInfoParams, { ImageTransparency = 1 }):Play()
	tweenservice:Create(LoadingScreen.notice, TInfoParams, { Position = UDim2.new(0.397, 0, 0.512, 0) }):Play()
	tweenservice:Create(LoadingScreen.name, TInfoParams, { Position = UDim2.new(0.397, 0, 0.475, 0) }):Play()
	LoadingScreen.Visible = false
	mainFrame.Visible = true
end)
