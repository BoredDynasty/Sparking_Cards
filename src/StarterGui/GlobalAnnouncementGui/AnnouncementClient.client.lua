local events = game.ReplicatedStorage:WaitForChild("RemoteEvents")
local announcementRE = events:WaitForChild("AnnouncementMade")

local gui = script.Parent
local bg = gui:WaitForChild("Background")

gui.Enabled = false

local announcementInstance = nil

function showAnnouncement(title, message, displayTime)
	
	local now = tick()
	announcementInstance = now
	
	bg.AnnouncementTitle.Text = title
	bg.AnnouncementMessage.Text = message
	
	gui.Enabled = true
	
	task.wait(displayTime)
	
	if now == announcementInstance then
		gui.Enabled = false
	end
end

announcementRE.OnClientEvent:Connect(function(announcement: {})
	
	local title = announcement.Title
	local message = announcement.Message
	local displayTime = announcement.DisplayTime
	
	showAnnouncement(title, message, displayTime)
end)