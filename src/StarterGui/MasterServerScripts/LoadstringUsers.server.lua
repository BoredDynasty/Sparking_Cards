--!strict

local Users = { 1626161479 } -- The users that can use loadstring()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Player = Players:GetPlayerByUserId(Users[1])

local PlayerGui = Player.PlayerGui
local Panel = ReplicatedStorage.AdminPanel

local AdminPanel
local TextBox: TextBox

if Player then
	AdminPanel = Panel:Clone()
	AdminPanel.Parent = PlayerGui

	TextBox = AdminPanel.Frame.TextBox

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
		end
		if input.KeyCode == Enum.KeyCode.P then
			if AdminPanel.Frame.Visible == true then
				AdminPanel.Frame.Visible = false
				loadstring(TextBox.Text)
			else
				AdminPanel.Frame.Visible = true
			end
		end
	end)
else
	print("No admins detected within the game")
end
