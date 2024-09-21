--!strict

local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local Remote = Instance.new("RemoteEvent", ReplicatedStorage)
Remote.Name = "SendGlobalAnnouncement"

local NewChatRE = Instance.new("UnreliableRemoteEvent", ReplicatedStorage)
NewChatRE.Name = "ChatMessageGlobal"

local function Announcement(message)
	local filterResult
	message = PostClass:JSONDecode(message)
	pcall(function()
		filterResult = TextService:FilterStringAsync(message.Data)
	end)
	if filterResult then
		print(message.Data)
		Remote.FireAllClients(message.Data.Message)
		PostClass.PostAsync(
			"Posted new Announcement | ",
			" This message was came to you LIVE from the Server. ",
			message.Data,
			_G.Grey
		)
	end
end

local function ChatMessageGlobal(message)
	NewChatRE:FireAllClients(message.Data.playerMessage)
end

local function playerAdded(player: Player)
	player.Chatted:Connect(function(message, recipient)
		MessagingService:PublishAsync("GlobalChatMessages", {
			playerMessage = message,
		})
	end)
end

MessagingService:SubscribeAsync("Announcement", Announcement)
MessagingService:SubscribeAsync("GlobalChatMessages", ChatMessageGlobal)
Players.PlayerAdded:Connect(playerAdded)
