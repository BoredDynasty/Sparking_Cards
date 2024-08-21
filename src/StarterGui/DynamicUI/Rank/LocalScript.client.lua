local top = script.Parent.Top
local bottom = script.Parent.Bottom

local Parent = script.Parent

local text = script.Parent.RankUp

local event = game.ReplicatedStorage.RemoteEvents.RankUp
local tween = game:GetService("TweenService")
local TweenInfo1 = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine
)

local TweenInfo2 = TweenInfo.new(
	1,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

local function Setup()	
	top.Visible = true
	bottom.Visible = true
	text.Visible = true
	top.Position = UDim2.new(-2.021, -0.069, 0)
	bottom.Position = UDim2.new(-2.028, 0, 0.759, 0)
	task.wait(0.1)
	tween:Create(text, TweenInfo1, {Position = UDim2.new(0.174, 0, 0.398, 0)}):Play()
	tween:Create(top, TweenInfo2, {Position = UDim2.new(-0.021, 0, -0.069, 0)}):Play()
	tween:Create(bottom, TweenInfo2, {Position = UDim2.new(-0.028, 0, 0.713, 0)}):Play()
end

local function endSetup()
	tween:Create(text, TweenInfo1, {Position = UDim2.new(2.174, 0, 0.398, 0)}):Play()
	tween:Create(top, TweenInfo2, {Position = UDim2.new(-2.021, 0, -0.069, 0)}):Play()
	tween:Create(bottom, TweenInfo2, {Position = UDim2.new(-2.028, 0, 0.759, 0)}):Play()
	top.Visible = false
	bottom.Visible = false
	text.Visible = false
end

event.OnClientEvent:Connect(function(waitTime: number, isLetterBox: boolean) 
	print("Recieved OnClientEvent Rankup")
	if isLetterBox == true then
		Setup()
		task.wait(waitTime)
		endSetup()
		end
end)
