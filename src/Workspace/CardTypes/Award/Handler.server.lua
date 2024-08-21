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
	local Player = Players:GetPlayerFromCharacter(otherPart.Parent)
	if not Player then
		return
	end
	
	local currentBalance = Player:FindFirstChild("leaderstats").Cards.Value
	
	if not currentBalance then 
		return 
	end
	
	RewardEvent:FireClient(Player, 3)
	
	Analytics:LogEconomyEvent(
		Player,
		Enum.AnalyticsEconomyFlowType.Source,
		"Cards",
		3,
		tonumber(currentBalance),
		Enum.AnalyticsEconomyTransactionType.Onboarding.Name
	)
	
	end)