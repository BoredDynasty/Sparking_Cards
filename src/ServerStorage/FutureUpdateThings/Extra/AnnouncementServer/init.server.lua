local whitelist = {1626161479}


local events = game.ReplicatedStorage:WaitForChild("RemoteEvents")
local announcementRE = events:WaitForChild("AnnouncementMade")

local messagingService = game:GetService("MessagingService")

function validatePlayer(plr: Player)
	
	if table.find(whitelist, plr.UserId) then
		return true
	else
		return false
	end
end

--Giving whitelisted players the GUI
local gui = script:WaitForChild("AnnouncementCreatorGui")

function playerAdded(plr: Player)
	
	if validatePlayer(plr) then
		
		gui:Clone().Parent = plr.PlayerGui
	end
end

game.Players.PlayerAdded:Connect(playerAdded)

local textService = game:GetService("TextService")

function filterMessage(message: string, senderId: number)

	local filterResult
	pcall(function()
		filterResult = textService:FilterStringAsync(message, senderId)
	end)

	if filterResult then

		local text
		pcall(function()
			text = filterResult:GetNonChatStringForBroadcastAsync()
		end)

		if text then
			return text
		end
	end
end

--Sending announcements
function createAnnouncement(plr: Player, announcement: {})
	
	if not announcement.Title then
		announcement.Title = ""
	else
		announcement.Title = filterMessage(announcement.Title, plr.UserId)
	end
	
	if not announcement.Message then
		announcement.Message = ""
	else
		announcement.Message = filterMessage(announcement.Message, plr.UserId)
	end
	
	if not tonumber(announcement.DisplayTime) then
		announcement.DisplayTime = 30
	end
	
	messagingService:PublishAsync("Announcements", announcement)
end

announcementRE.OnServerEvent:Connect(function(plr, announcement)
	
	if validatePlayer(plr) then
		
		createAnnouncement(plr, announcement)
	end
end)

--Receiving announcements
messagingService:SubscribeAsync("Announcements", function(announcement)
	
	announcementRE:FireAllClients(announcement.Data)
end)