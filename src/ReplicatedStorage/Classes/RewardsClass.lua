--!strict
local Class = {}
Class.AddCardsValue = 20

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Analytics = game:GetService("AnalyticsService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local PassID = 891181374

function Class.NewReward(
	player: Player,
	AddCards: number,
	CurrentRank: string,
	CurrentMultiplier: string,
	ExperiencePoints: number
) -- Rewards the player
	local LeaderstatsFolder: Folder = player:FindFirstChild("leaderstats")
	local Cards: IntValue = LeaderstatsFolder:FindFirstChild("Cards")
	local Rank: StringValue = LeaderstatsFolder:FindFirstChild("Rank")
	local Multiplier: StringValue = LeaderstatsFolder:FindFirstChild("MultiplierType")
	local Experience: NumberValue = LeaderstatsFolder:FindFirstChild("ExperiencePoints")
	if not AddCards then
		AddCards = GlobalSettings.DefaultAward
	end
	if not Experience then
		ExperiencePoints = GlobalSettings.DefaultAward / 5
	end

	-- i hadda do type checking cuz roblox is quite stoopid

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
			PostClass.PostAsync("Player has Double Cards Pass. ", player.Name)
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
end

return Class
