--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local SendRemote = ReplicatedStorage.RemoteEvents:FindFirstChildOfClass("UnreliableRemoteEvent") -- that remote event is really really unreliable

local color = 15844367 -- i think this is purple or orange or smthing
local Debounce = false

local Frame = script.Parent.Parent:WaitForChild("HelpHud"):WaitForChild("Help")

local Yes = Frame.Yes
local No = Frame.No

local TextBox: TextBox = Frame.Feedback

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
	end
	if input.KeyCode == Enum.KeyCode.F2 then
		if Frame.Visible == true then
			Frame.Visible = false
		else
			Frame.Visible = true
		end
	end
end)

Yes.MouseButton1Down:Once(function() -- this "once" is keeping the whole script in place
	SendRemote:FireServer("Player Help Request | " .. game.Players.LocalPlayer.Name, TextBox.Text, color)
	TextBox.Text = ""
	TextBox.PlaceholderText = "Request Sent. You can only press once"
end)

No.MouseButton1Down:Connect(function()
	Frame.Visible = false
	TextBox.Text = ""
end)
