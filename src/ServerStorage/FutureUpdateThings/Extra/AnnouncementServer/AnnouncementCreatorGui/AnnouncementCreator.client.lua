local gui = script.Parent
local openBtn = gui:WaitForChild("OpenButton")
local frame = gui:WaitForChild("CreatorFrame"); frame.Visible = false
local closeBtn = frame:WaitForChild("CancelButton")
local submitBtn = frame:WaitForChild("SubmitButton")

local events = game.ReplicatedStorage:WaitForChild("RemoteEvents")
local announcementRE = events:WaitForChild("AnnouncementMade")

--Opening and closing the GUI
function open()
	
	frame.Visible = true
end

function close()
	
	frame.Visible = false
	
	frame.TitleBox.Text = ""
	frame.MessageBox.Text = ""
	frame.DisplayTimeBox.Text = ""
end

openBtn.MouseButton1Click:Connect(function()
	
	if frame.Visible == false then
		open()
	else
		close()
	end
end)

closeBtn.MouseButton1Click:Connect(close)

--Submitting an announcement
function getAnnouncement()
	
	local announcement = {}
	
	announcement.Title = frame.TitleBox.Text
	announcement.Message = frame.MessageBox.Text
	announcement.DisplayTime = frame.DisplayTimeBox.Text
	
	return announcement
end

function submitAnnouncement()
	
	local announcement = getAnnouncement()
	announcementRE:FireServer(announcement)
	
	close()
end

submitBtn.MouseButton1Click:Connect(submitAnnouncement)