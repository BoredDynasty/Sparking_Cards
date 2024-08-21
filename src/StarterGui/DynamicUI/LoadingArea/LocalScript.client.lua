--!strict
-- Loading Screen Script
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(
	0.35,
	Enum.EasingStyle.Sine
)

local Remote = ReplicatedStorage.RemoteEvents.SpecificUIHide.LoadingArea

local Frame = script.Parent.Background
local LoadingText = Frame.Loading
local Indicator = LoadingText.dropshadow_16_20

Remote.OnClientEvent:Connect(function(mapSize: number)
	if not mapSize then
		mapSize = 1.5
	end
	TweenService:Create(Frame, TweenParams, {Position = UDim2.new(0.5, 0, 0.5, 0)})
	TweenService:Create(Indicator, TweenParams, {ImageColor3 = Color3.fromHex("#ffff7f")})
	LoadingText.Text = "Connecting..."
	task.wait(tonumber(math.floor(mapSize * 5)))
	LoadingText.Text = "Connected."
	TweenService:Create(Indicator, TweenParams, {ImageColor3 = Color3.fromHex("#55ff7f")})
	task.wait(4)
	TweenService:Create(Frame, TweenParams, {Position = UDim2.new(-2, 0, 0.5, 0)})
end)