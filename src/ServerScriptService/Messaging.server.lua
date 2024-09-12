--!strict

local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local AnnouncementRemote = ReplicatedStorage:WaitForChild("SendGlobalAnnouncement")
if not AnnouncementRemote then
	local Remote = Instance.new("RemoteEvent", ReplicatedStorage)
	Remote.Name = "SendGlobalAnnouncement"
end

MessagingService:SubscribeAsync("Announcement", function(message)
	local filterResult
	message = PostClass:JSONDecode(message)
	pcall(function()
		filterResult = TextService:FilterStringAsync(message.Data)
	end)
	if filterResult then
		print(message.Data)
		AnnouncementRemote.FireAllClients(message.Data)
		PostClass.PostAsync(
			"Posted new Announcement | ",
			" This message was came to you LIVE from the Server. ",
			message.Data,
			tonumber(_G.Grey)
		)
	end
end)
