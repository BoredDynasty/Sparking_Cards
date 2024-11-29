--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local AnalyticsService = game:GetService("AnalyticsService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local PassID = 891181374

--[=[
	Creates a new Reward for a player.
		@param player Player
		@param AddCards number
		@param CurrentRank string
		@param CurrentMultiplier string
		@param ExperiencePoints number
--]=]
return function(player: Player, AddCards: number, CurrentRank: string, CurrentMultiplier: string)
	local LeaderstatsFolder: Folder = player:FindFirstChild("leaderstats")
	local Cards: IntValue = LeaderstatsFolder:FindFirstChild("Cards")
	local Rank: StringValue = LeaderstatsFolder:FindFirstChild("Rank")
	local Multiplier: StringValue = LeaderstatsFolder:FindFirstChild("MultiplierType")

	if not AddCards then
		AddCards = GlobalSettings.DefaultAward
	end

	local hasPass = false

	pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, PassID)
	end)

	if AddCards then
		if hasPass then
			Cards.Value += AddCards * 2
			AnalyticsService:LogEconomyEvent(
				player,
				Enum.AnalyticsEconomyFlowType.Source,
				"Cards",
				AddCards * 2,
				Cards,
				Enum.AnalyticsEconomyTransactionType.Gameplay
			)
		else
			Cards.Value += math.ceil(AddCards)
			AnalyticsService:LogEconomyEvent(
				player,
				Enum.AnalyticsEconomyFlowType.Source,
				"Cards",
				AddCards,
				Cards,
				Enum.AnalyticsEconomyTransactionType.Gameplay
			)
		end
	end

	if CurrentRank then
		if CurrentRank == "Bronze I" then
			Rank.Value = "Gold II"
		elseif CurrentRank == "Gold II" then
			Rank.Value = "Platinum III"
		elseif CurrentRank == "Platinum III" then
			Rank.Value = "Master IV"
		elseif CurrentRank == "Master IV" then
			Rank.Value = "Sparking V"
			return true
		end
	end

	if CurrentMultiplier then
		if CurrentMultiplier == "Untitled" then
			Multiplier.Value = "Chaos Indefinite"
		elseif CurrentMultiplier == "Chaos Indefinite" then
			Multiplier.Value = "Chaos Coloring"
		elseif CurrentMultiplier == "Chaos Coloring" then
			Multiplier.Value = "Absolute Sparking"
		end
	end
end
