local part = script.Parent

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")

local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

part.Touched:Connect(function(otherPart: BasePart) 
	local player = Players:GetPlayerFromCharacter(otherPart.Parent)
	local guiShop = player.PlayerGui.DynamicUI.BuyCards
	
	if player then
		TweenService:Create(guiShop.Frame, TweenParams, {Position = UDim2.new(0.5, 0, 0.901, 0)}):Play()
		Analytics:LogCustomEvent(
			player,
			"Player Viewing Gamepass Shop",
			2
		)
	end
end)

part.TouchEnded:Connect(function(otherPart: BasePart) 
	local player = Players:GetPlayerFromCharacter(otherPart.Parent)
	local guiShop = player.PlayerGui.DynamicUI.BuyCards

	if not player or player then
		TweenService:Create(guiShop.Frame, TweenParams, {Position = UDim2.new(0.5, 0, 1.901, 0)}):Play()
		Analytics:LogCustomEvent(
			player,
			"Player Exiting Gamepass Shop",
			2
		)
	end
end)