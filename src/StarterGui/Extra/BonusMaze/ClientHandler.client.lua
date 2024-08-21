local Frame = script.Parent.Time

local BuyButton = Frame.Time

local UIGradient = BuyButton.UIStroke.UIGradient

game:GetService("TweenService"):Create(
	UIGradient, 
	TweenInfo.new(3, 
		Enum.EasingStyle.Linear, 
		Enum.EasingDirection.In, 
		math.huge, 
		true), {
		Rotation = 360}
):Play()
	
