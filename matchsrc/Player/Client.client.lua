--!strict

-- Client.client.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Choices
local cardChoices = {
	Fire = Enum.KeyCode.One,
	Frost = Enum.KeyCode.Two,
}

local function getChoice(input, gameProcessed)
	if gameProcessed then
		return
	end
	for choice, keyCode in pairs(cardChoices) do
		if input.KeyCode == keyCode then
			return choice
		end
	end
end

local function onInputBegan(input, gameProcessed)
	local choice = getChoice(input, gameProcessed)
	if choice then
		print("Player chose: ", choice)
		-- Send choice to server
		local sendCardChoice = ReplicatedStorage.RemoteEvents.SendCardChoice
		sendCardChoice:FireServer(choice)
		player:SetAttribute("Card", choice)
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
