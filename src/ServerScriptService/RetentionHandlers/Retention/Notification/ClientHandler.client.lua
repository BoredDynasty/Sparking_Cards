local Frame = script.Parent.Frame

local GiftButton = Frame.Gift
local BuyButton = Frame.Buy

for i, v in pairs(Frame) do
	if v:IsA("UIGradient") then
		game:GetService("TweenService"):Create(
		v, 
		TweenInfo.new(3, 
			Enum.EasingStyle.Linear, 
			Enum.EasingDirection.In, 
			math.huge, 
			true), {
			Rotation = 360}
		):Play()

	end
end
