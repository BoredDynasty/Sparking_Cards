--!nocheck
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

print("Economic Analytics are enabled.")
print("Custom Analytics are enabled.")

local productFunctions = {}

-- This product Id gives the player more cards (cards as in money)
productFunctions[1904591683] = function(receipt, player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	local leaderstats = player:FindFirstChild("leaderstats")
	local multiplier = leaderstats:FindFirstChild("MultiplierType")
	local Cards = leaderstats and leaderstats:FindFirstChild("Cards")
	--[[
	local MultiplierNumber
	
	if multiplier.Value == "Untitled" then
		MultiplierNumber = 1
	elseif multiplier.Value == "Chaos Indefinite" then
		MultiplierNumber = 1.5
	elseif multiplier.Value == "Chaotic Coloring" then
		MultiplierNumber = 2.4
	elseif multiplier.Value == "Absolute Sparking" then
		MultiplierNumber = 3
	end
	--]]
	if Cards then
		--local newMultiplier = math.ceil(50 * MultiplierNumber)
		--Cards.Value += newMultiplier
		Cards.Value += 50
		task.wait(1)
		AnalyticsService:LogEconomyEvent(
			player,
			Enum.AnalyticsEconomyFlowType.Source,
			"Cards",
			50,
			Cards.Value,
			Enum.AnalyticsEconomyTransactionType.IAP.Name,
			"50_Cards"
		)
	end

	return true -- indicate a successful purchase
end

productFunctions[1906572512] = function(receipt, player)
	local alreadyDonated = {}
	if not table.find(alreadyDonated, player.Name) then
		table.insert(alreadyDonated, player.Name)
		print("Donated Successfully!")
		AnalyticsService:LogOnboardingFunnelStepEvent(player, 4, "Donation")
		task.wait(10)
		table.clear(alreadyDonated)
	end
end

local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = Players:GetPlayerByUserId(userId)
	if player then
		-- Get the handler function associated with the developer product ID and attempt to run it
		local handler = productFunctions[productId]
		local success, result = pcall(handler, receiptInfo, player)
		if success then
			-- The user has received their benefits
			-- Return "PurchaseGranted" to confirm the transaction
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	-- The user's benefits couldn't be awarded
	-- Return "NotProcessedYet" to try again next time the user joins
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Set the callback; this can only be done once by one server-side script
MarketplaceService.ProcessReceipt = processReceipt
