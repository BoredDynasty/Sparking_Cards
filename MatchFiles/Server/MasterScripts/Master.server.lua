--!nocheck

print("Server ID [ " .. game.JobId .. " ]: Match")

local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")

local DataStoreClass = require(ReplicatedStorage.Classes.DataStoreClass)
local LoadingClass = require(ReplicatedStorage.Classes.LoadingClass)

local DialogRE: RemoteEvent = ReplicatedStorage.RemoteEvents.NewDialogue

local productFunctions = {}

print("Economic Analytics are enabled.")
print("Custom Analytics are enabled.")

local function touchDialog(otherPart: BasePart, player)
	if not player then
		player = Players:GetPlayerFromCharacter(otherPart.Parent)
	end
	local message = otherPart:GetAttribute("TouchDialog") or otherPart:GetAttribute("DialogText")
	if message then
		DialogRE:FireClient(player, message)
		print(`Sending Dialog to {player.DisplayName}: {message}`)
	end
end

-- This product Id gives the player more cards (cards as in money)
productFunctions[1904591683] = function(receipt, player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local Cards: IntValue = leaderstats and leaderstats:FindFirstChild("Cards")
	if Cards then
		Cards.Value += 50
		AnalyticsService:LogEconomyEvent(
			player,
			Enum.AnalyticsEconomyFlowType.Source,
			"Cards",
			50,
			DataStoreClass:getPlayerStats().Value,
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

local function chatted(player, message)
	if string.find(message, "@quit") or string.find(message, "@ggs") then
		player:Kick("You've quitted the match. ggs!")
	end
end

local function onPlayerAdded(player)
	DataStoreClass.PlayerAdded(player)
	local customFields = {
		[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = "SPARKING-MATCH",
	}
	AnalyticsService:LogOnboardingFunnelStepEvent(player, 1, "Player Joined", customFields)
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
	local customFields = {
		[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = "SPARKING-MATCH",
	}
	AnalyticsService:LogOnboardingFunnelStepEvent(player, 1, "Player Leaving", customFields)
	player:Destroy() -- performance reasons
end

local function addDestinations()
	local cooldown = {}
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
		for _, tag in CollectionService:GetTagged("DialogTrigger") do
			local otherPart: BasePart? = tag
			otherPart.Touched:Connect(function(player)
				if not table.find(cooldown, player) then
					table.insert(cooldown, player)
					touchDialog(otherPart, player)
					task.wait(10)
					table.remove(cooldown, player)
				end
			end)
			if otherPart:FindFirstChildOfClass("ClickDetector") then
				local clickDetect = otherPart:FindFirstChildOfClass("ClickDetector")
				clickDetect.MouseClick:Connect(function(player)
					if not table.find(cooldown, player) then
						table.insert(cooldown, player)
						touchDialog(otherPart, player)
						task.wait(10)
						table.remove(cooldown, player)
					end
				end)
			end
		end
	end)
end

-- Set the callback; this can only be done once by one server-side script
MarketplaceService.ProcessReceipt = processReceipt
DataStoreClass.StartBindToClose()
addDestinations()
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
