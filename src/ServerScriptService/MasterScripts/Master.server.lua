--!nocheck
-- This script is also a command script!

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)
local AnalyticsClass = require(ReplicatedStorage.Classes.AnalyticsClass)

local productFunctions = {}

local Contributers = { Dynasty = 1626161479 }
local ContributerBadge = 2817914035578656

print("Economic Analytics are enabled.")
print("Custom Analytics are enabled.")

Players.PlayerAdded:Connect(function(player)
	DataStoreClass.PlayerAdded(player)
	player.CharacterRemoving:Connect(function(character)
		task.defer(character.Destroy, character)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	DataStoreClass.PlayerRemoving(player)
	task.defer(player.Destroy, player)
end)

-- This product Id gives the player more cards (cards as in money)
productFunctions[1904591683] = function(receipt, player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	local leaderstats = player:FindFirstChild("leaderstats")
	local multiplier = leaderstats:FindFirstChild("MultiplierType")
	local Cards = leaderstats and leaderstats:FindFirstChild("Cards")
	if Cards then
		--local newMultiplier = math.ceil(50 * MultiplierNumber)
		--Cards.Value += newMultiplier
		Cards.Value += 50
		task.wait(1)
		AnalyticsClass:LogEconomyEvent(
			player,
			Enum.AnalyticsEconomyFlowType.Source,
			50,
			Enum.AnalyticsEconomyTransactionType.IAP.Name,
			"50_Cards"
		)
	end
	return true -- indicate a successful purchase
end

productFunctions[1906572512] = function(receipt, player)
	local alreadyDonated: {} = {} :: {} -- unessecary lmao
	if not table.find(alreadyDonated, player.Name) then
		table.insert(alreadyDonated, player.Name)
		print("Donated Successfully!")
		AnalyticsClass:LogOnboardingFunnelStepEvent(player, "Donation", 5)
		task.wait(10)
		table.clear(alreadyDonated)
	end
end

local Clone = ReplicatedStorage.Assets.Server:Clone()
Clone.Parent = workspace

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

DataStoreClass.StartBindToClose(DataStoreClass.StartBindToClose)
