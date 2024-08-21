local Remote = game:GetService("ReplicatedStorage").RemoteEvents.GiftPlayer
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

local Frame = script.Parent.Frame

local GiftButton = Frame.Gift
local BuyButton = Frame.Buy

local UIGradient = BuyButton.UIStroke.UIGradient -- we are going to make the "buy button" more enticing.

game:GetService("TweenService"):Create(
	UIGradient, 
	TweenInfo.new(3, 
		Enum.EasingStyle.Linear, 
		Enum.EasingDirection.In, 
		math.huge, 
		true), {
		Rotation = 360}
):Play()
	

local productId = 1904591683

function promptPurchase()
	MarketplaceService:PromptProductPurchase(LocalPlayer, productId)
end

BuyButton.MouseButton1Down:Connect(promptPurchase)
