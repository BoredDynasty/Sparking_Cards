--!nocheck

-- // Services
local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

-- // Variables

local AwardClass = require(ReplicatedStorage.Classes.RewardsClass)

local AwardableTag = CollectionService:GetTagged("Awardable")

for _, Awardable in AwardableTag do
	local AwardablePart = Awardable

	AwardablePart.Touched:Once(function(otherPart)
		local Player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
		if Player then
			AwardClass.NewReward(Player, 50)
		else
			print("?")
		end
	end)
end

for _, part: Part in CollectionService:GetTagged("ShopPart") do
	local shopPart = part
	shopPart.Touched:Connect(function(otherPart)
		local debounce = false
		if debounce == false then
			debounce = true
			local player = Players:GetPlayerFromCharacter(otherPart.Parent)
			if player then
				local buyCards = player.PlayerGui.DynamicUI.BuyCards
				local buyFrame = buyCards.Frame
				TweenService:Create(
					buyFrame,
					TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut),
					{ Position = UDim2.fromScale(0.5, 0.9) }
				):Play()
				task.wait(5)
				debounce = false
			end
		end
	end)
	shopPart.TouchEnded:Connect(function(otherPart)
		local player = Players:GetPlayerFromCharacter(otherPart.Parent)
		if player then
			local buyCards = player.PlayerGui.DynamicUI.BuyCards
			local buyFrame = buyCards.Frame
			TweenService:Create(
				buyFrame,
				TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut),
				{ Position = UDim2.fromScale(0.5, 9) }
			):Play()
		end
	end)
end
