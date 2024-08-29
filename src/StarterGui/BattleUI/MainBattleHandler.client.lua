--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local RemoteFolder = ReplicatedStorage.RemoteEvents
local PlayCardRemote: RemoteEvent = RemoteFolder.PlayCard

local MatchSettings = require(ReplicatedStorage.GlobalSettings)

local TInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local CurrentVictim
RemoteFolder.EnemyTurn.OnClientEvent:Connect(function(victim: Player)
	CurrentVictim = victim
end)

local DrawCardsButton = script.Parent.Draw

local frame = script.Parent.drawCardsFrame
local TextBox: TextBox = frame.InputCard

local ValidCards = MatchSettings.ValidCards

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
	end

	if input.KeyCode == Enum.KeyCode.G then
		if frame.Visible == false then
			frame.Visible = true
		else
			frame.Visible = false
		end
	end
end)

DrawCardsButton.MouseButton1Down:Connect(function()
	if frame.Visible == false then
		frame.Visible = true
	else
		frame.Visible = false
	end
end)

while true do
	task.wait()
	TextBox.PlaceholderText = "Input A Card You Would Like to Use. The Match will continue in "
		.. MatchSettings.MaxChoosingTime
	task.wait(MatchSettings.MaxChoosingTime)
	break
end

if
	not TextBox.Text == MatchSettings.ValidCards[1]
	or MatchSettings.ValidCards[2]
	or MatchSettings.ValidCards[3]
	or MatchSettings.ValidCards[4]
then
	TextBox.TextColor3 = Color3.fromHex("#ff4e41")
else
	TextBox.TextColor3 = Color3.new(255, 255, 255)
	RemoteFolder.PlayCard:FireServer(CurrentVictim, TextBox.Text)
end
