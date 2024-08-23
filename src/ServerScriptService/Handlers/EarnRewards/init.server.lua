--!strict

-- // Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Analytics = game:GetService("AnalyticsService")

-- // Variables

local Remote = ReplicatedStorage.RemoteEvents.AwardPlayer

local PassID = 891181374

Remote.OnServerEvent:Connect(function(player: Player, AddCards: number, CurrentRank: string, CurrentMultiplier: string)
	local LeaderstatsFolder = player:FindFirstChild("leaderstats")
	local Cards = LeaderstatsFolder:FindFirstChild("Cards")
	local Rank = LeaderstatsFolder:FindFirstChild("Rank")
	local Multiplier = LeaderstatsFolder:FindFirstChild("MultiplierType")

	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, PassID)
	end)

	if not success then
		warn("We had an error checking if " .. tostring(player.Name) .. " has the Double Cards gamepass. " .. message)
		return
	end

	if AddCards then
		if hasPass then
			Cards.Value += math.ceil(AddCards * 2)
		else
			Cards.Value += math.ceil(AddCards)
			MarketplaceService:PromptGamePassPurchase(player, PassID)
			print("You're gonna need it!")
		end
	end

	if CurrentRank then
		if CurrentRank == "Bronze I" then
			Rank.Value = "Gold II"
		elseif CurrentRank == "Gold II" then
			Rank.Value = "Platinum III"
		elseif CurrentRank == "Master IV" then
			Rank.Value = "Sparking V"
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
end)
