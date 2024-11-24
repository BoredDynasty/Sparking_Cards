--!nocheck

print("Server ID [ " .. game.JobId .. " ]")

local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")

local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)
local SafeTeleporter = require(ReplicatedStorage.Modules.SafeTeleporter)
local LoadingClass = require(ReplicatedStorage.Classes.LoadingClass)
local MatchHandler = require(ReplicatedStorage.Modules.MatchHandler)

local FastTravelRE: RemoteFunction = ReplicatedStorage.RemoteEvents.FastTravel
local EnterMatchRE: RemoteFunction = ReplicatedStorage.RemoteEvents
local DialogRE: RemoteEvent = ReplicatedStorage.RemoteEvents.NewDialogue

local productFunctions = {}

print("Economic Analytics are enabled.")
print("Custom Analytics are enabled.")

local function touchDialog(otherPart: BasePart, player)
	local message = otherPart:GetAttribute("TouchDialog")
	DialogRE:FireClient(player, message)
end

-- This product Id gives the player more cards (cards as in money)
productFunctions[1904591683] = function(receipt, player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local Cards = leaderstats and leaderstats:FindFirstChild("Cards")
	if Cards then
		--local newMultiplier = math.ceil(50 * MultiplierNumber)
		--Cards.Value += newMultiplier
		Cards.Value += 50
		AnalyticsService:LogEconomyEvent(
			player,
			Enum.AnalyticsEconomyFlowType.Source,
			"Cards",
			50,
			DataStoreClass:getPlayerStats(),
			Enum.AnalyticsEconomyTransactionType.IAP.Name,
			"Extra Cards"
		)
		local customFields = {
			[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = tostring(receipt),
			[Enum.AnalyticsCustomFieldKeys.CustomField03.Name] = player.Name,
			[Enum.AnalyticsCustomFieldKeys.CustomField02.Name] = player.UserId,
		}
		AnalyticsService:LogCustomEvent(player, "Receipts", 1, customFields)
		task.wait(1)
	end
	return true -- indicate a successful purchase
end

productFunctions[1906572512] = function(receipt, player)
	local alreadyDonated = {}
	if not table.find(alreadyDonated, player.Name) then
		table.insert(alreadyDonated, player.Name)
		print("Donated Successfully!")
		task.wait(10)
		table.clear(alreadyDonated)
	end
	local customFields = {
		[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = tostring(receipt),
		[Enum.AnalyticsCustomFieldKeys.CustomField03.Name] = player.Name,
		[Enum.AnalyticsCustomFieldKeys.CustomField02.Name] = player.UserId,
	}
	AnalyticsService:LogCustomEvent(player, "Receipts", 1, customFields)
	return true
end

local Clone = ReplicatedStorage.Assets.Server:Clone()
Clone.Parent = game.Workspace

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
			warn("Failed to process receipt: ", receiptInfo, result)
		end
	end

	-- The user's benefits couldn't be awarded
	-- Return "NotProcessedYet" to try again next time the user joins
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

local function FastTravel(place: number, players: { Player }, options)
	return SafeTeleporter(place, players, options)
end

local function enterMatch(players: { Player }, _)
	return task.spawn(function()
		for _, player in players do
			MatchHandler.addPlayer(player)
		end
		while true do
			task.wait(10)
			MatchHandler.new()
		end
	end)
end

local function chatted(player, message)
	if string.find(message, "@match") or string.find(message, "@ready") then
		enterMatch({ player })
	end
end

local function onPlayerAdded(player)
	DataStoreClass.PlayerAdded(player)
	AnalyticsService:LogOnboardingFunnelStepEvent(player, 1, "Player Joined")
	player.Character.Animate.walk.WalkAnim.AnimationId = "rbxassetid://14512867805"
	player.CharacterRemoving:Connect(function(character)
		task.defer(character.Destroy, character)
	end)
	player.Chatted:Connect(function(message)
		chatted(player, message)
	end)
end

local function onPlayerRemoving(player)
	DataStoreClass.PlayerRemoving(player)
	AnalyticsService:LogOnboardingFunnelStepEvent(player, 1, "Player Leaving")
	player:Destroy() -- performance reasons
end

local function addDestinations()
	return task.spawn(function()
		for _, tag in pairs(CollectionService:GetTagged("TeleportPart")) do
			local Teleport = tag

			local destination = Teleport:GetAttribute("Destination")

			Teleport.ClickDetector.MouseClick:Connect(function(player)
				LoadingClass(1.3, player)
				task.wait(1)
				player.Character.HumanoidRootPart:PivotTo(destination)
			end)
		end
		for _, tag in CollectionService:GetTagged("TouchDialog") do
			local otherPart: BasePart? = tag
			local cooldown = {}
			otherPart.Touched:Connect(function(player)
				if not table.find(cooldown, otherPart) then
					table.insert(cooldown, otherPart)
					touchDialog(otherPart, player)
					task.wait(10)
					table.remove(cooldown, otherPart)
				end
			end)
		end
	end)
end

-- Set the callback; this can only be done once by one server-side script
MarketplaceService.ProcessReceipt = processReceipt
DataStoreClass.StartBindToClose()
addDestinations()
FastTravelRE.OnServerInvoke(function(...: any)
	FastTravel(...)
end)
EnterMatchRE.OnServerInvoke(function(...: any)
	enterMatch(...)
end)
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
