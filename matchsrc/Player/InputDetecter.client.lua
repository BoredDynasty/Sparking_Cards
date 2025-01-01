--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local AttackRE = ReplicatedStorage.RemoteEvents.Attack
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local card: string = player:GetAttribute("Card")
local cardChoices = {
	Fire = Enum.KeyCode.One,
	Frost = Enum.KeyCode.Two,
}

local function onInputBegan(input, gameProcessed)
	if gameProcessed then
		return
	end
	for choice, keyCode in pairs(cardChoices) do
		if input.KeyCode == keyCode and choice == card then
			print("Player used: ", choice)
			-- Send attack to server
			AttackRE:FireServer(choice, mouse)
			--[[ 
			The server will handle the animations
			the attack itself
			and whatnot.
			--]]
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
