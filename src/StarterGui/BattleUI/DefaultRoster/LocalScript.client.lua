local frame1 = script.Parent.CardFrame1
local frame2 = script.Parent.CardFrame2
local frame3 = script.Parent.CardFrame3

local started = game.ReplicatedStorage.RemoteEvents.MatchStarted
local ended = game.ReplicatedStorage.RemoteEvents.MatchEnded

local ti = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine
)

local tween = game:GetService("TweenService")

local frame = script.Parent.Design

frame.LeftSelect.MouseEnter:Connect(function(x: number, y: number) 
	frame2.ZIndex = 2
	frame1.ZIndex = 1
	frame3.ZIndex = 1
end)

frame.RightSelect.MouseEnter:Connect(function(x: number, y: number) 
	frame2.ZIndex = 1
	frame1.ZIndex = 1
	frame3.ZIndex = 2
end)

frame.MiddleSelect.MouseEnter:Connect(function(x: number, y: number) 
	frame2.ZIndex = 1
	frame1.ZIndex = 2
	frame3.ZIndex = 1
	
end)

frame.MouseLeave:Connect(function(x: number, y: number) 
	frame2.ZIndex = 1
	frame1.ZIndex = 1
	frame3.ZIndex = 1
end)

started.OnClientEvent:Connect(function(...: any) 
	tween:Create(frame, ti, {Position = UDim2.new(0.301, 0, 0.622, 0)})
	frame1.Visible = true
	frame2.Visible = true
	frame3.Visible = true
end)

ended.OnClientEvent:Connect(function(...: any) 
	tween:Create(frame, ti, {Position = UDim2.new(0.301, 0, 1.622, 0)})
	frame1.Visible = false
	frame2.Visible = false
	frame3.Visible = false
end)