--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local AttackRE = ReplicatedStorage.RemoteEvents.Attack
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local function InputBegan(input: InputObject, gameProcessedEvent)
	if not gameProcessedEvent and input == Enum.KeyCode.G then
		AttackRE:FireServer("Frost", mouse)
	end
end

UserInputService.InputBegan:Connect(InputBegan)
