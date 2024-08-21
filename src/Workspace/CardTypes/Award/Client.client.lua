-- // Services

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- // Variables

local RewardEvent = ReplicatedStorage.RemoteEvents.AwardPlayer

local Part = script.Parent

-- // Functions

Part.Touched:Connect(function(otherPart: BasePart) 
	print("?")
	local Player = Players:GetPlayerFromCharacter(otherPart.Parent)
	if Player then
		local currentBalance = Player:WaitForChild("leaderstats").Cards.Value
		currentBalance += 3

		RewardEvent:FireServer(Player, 3)

		Analytics:LogEconomyEvent(
			Player,
			Enum.AnalyticsEconomyFlowType.Source,
			"Cards",
			3,
			tonumber(currentBalance),
			Enum.AnalyticsEconomyTransactionType.Onboarding.Name
		)

		print("Fired Server!" .. Part.Name)
	else
		print("??")
	end
end)
