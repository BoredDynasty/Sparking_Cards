--!nocheck

local CollectionService = game:GetService("CollectionService")
local DataStoreService = game:GetService("DataStoreService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local HostServerData = DataStoreService:GetDataStore("HostServerData")
local dataRetrieved = HostServerData:GetAsync("HostData")

local maxPlayers = 2
local placeID = 000
local serverForMode = ""

local gameMode1 = MemoryStoreService:GetSortedMap("GameMode1")

local ServerID = game.JobId
local IsServerHost = false

local function checkForConfirmedQueue(gamemode)
	if IsServerHost == true then
		local playerlist = gameMode1:GetRangeAsync(Enum.SortDirection.Descending, 5)
		if #playerlist == maxPlayers then
			local createdPlaceID = TeleportService:ReserveServer(placeID)

			local missingPlayers = {}
			local teleportingPlayers = {}

			for i, v in pairs(playerlist) do
				if game.Players:FindFirstChild(v) then
					table.insert(teleportingPlayers, Players:FindFirstChild(v))
				else
					table.insert(missingPlayers, v)
				end
			end

			TeleportService:TeleportToPrivateServer(placeID, createdPlaceID, teleportingPlayers)

			if #teleportingPlayers < maxPlayers then
				MessagingService:PublishAsync(
					"teleportPlayer",
					{ ["ServerID"] = createdPlaceID, ["Players"] = missingPlayers }
				)
			end
		end
	else
		if dataRetrieved[gamemode] == nil then
			IsServerHost = true
			dataRetrieved[gamemode] = ServerID
			HostServerData:UpdateAsync("HostData", dataRetrieved)
			MessagingService:PublishAsync("updateData", dataRetrieved)
		end
	end
end

local function addPlayerToQueue(player, mode)
	if player:GetAttribute("IsInQueue") ~= nil then
		return
	end

	player:SetAttribute("IsInQueue")

	if mode == "GameMode1" then
		gameMode1:SetAsync(tostring(player.UserId), ServerID)
	end
	checkForConfirmedQueue(mode)
end

ReplicatedStorage.RemoteEvents.JoinQueueEvent:Connect(function(player, gameMode)
	addPlayerToQueue(player, gameMode)
end)

MessagingService:SubscribeAsync("updateData", function(message)
	dataRetrieved = message.Data or HostServerData:GetAsync("HostData")
	-- update the host data of servers when host is changed
end)

MessagingService:SubscribeAsync("teleportPlayer", function(message)
	local playerList = message.Data["Players"]
	local serverID = message.Data["ServerID"]

	for _, player in pairs(playerList) do
		if Players:FindFirstChild(player) then
			-- if that player is in the game, teleport him to the place.
			TeleportService:TeleportToPrivateServer(placeID, serverID, Players:FindFirstChild(player))
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if IsServerHost == true and #Players:GetPlayers() <= 1 then
		dataRetrieved[serverForMode] = nil
		MessagingService:PublishAsync(dataRetrieved)
	end
	-- if player is in queue, remove him from the queue
	if player:GetAttribute("IsInQueue") == true then
		gameMode1:RemoveAsync(player.Name)
	end
end)

for _, queuePrompts in CollectionService:GetTagged("QueuePrompt") do
	if queuePrompts:IsA("ProximityPrompt") then
		queuePrompts.Triggered:Connect(function(player: Player)
			if not player:GetAttribute("IsInQueue") then
				addPlayerToQueue(player, queuePrompts.Parent.Name)

				local MatchMakingGUI = player.PlayerGui.DynamicUI.MatchMakingUI
				local indicator = MatchMakingGUI.CanvasGroup.Frame.indicator
				local text = MatchMakingGUI.CanvasGroup.Frame.Search

				local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

				local tween = TweenService:Create(
					MatchMakingGUI.CanvasGroup,
					UIEffectsClass:newTweenInfo(1.3, "Sine", "Out", 0, false, 0),
					{ GroupTransparency = 0 }
				)
				tween:Play()

				tween.Completed:Connect(function(playbackState: Enum.PlaybackState)
					if playbackState == Enum.PlaybackState.Completed then
						UIEffectsClass.Sound("Favorite")
						UIEffectsClass.changeColor("Blue", indicator)
						text.Text = "You've been added to queue."
					end
				end)

				task.wait(3)
				UIEffectsClass.changeColor("Orange", indicator)
				text.Text = "Almost there..."
			end
		end)
	end
end
