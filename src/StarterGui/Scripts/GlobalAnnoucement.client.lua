--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local AnnouncementRemote = ReplicatedStorage:WaitForChild("SendGlobalAnnouncement")

local GUI = script.Parent.Parent:WaitForChild("GlobalAnnouncementGui").Background

AnnouncementRemote.OnClientEvent:Connect(function(data)
	print(string.format("STUDIO : SERVER TESTING \nAnnoucement Made", "%q"))
	PostClass.PostAsync("Annoucement Made | ", data, "200")
	GUI.AnnouncementMessage.Text = data
end)
