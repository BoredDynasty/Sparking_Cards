--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local AttackRE = ReplicatedStorage.RemoteEvents.Attack
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local capabilities = {}

for attribute, value in player:GetAttributes() do
	table.insert(capabilities, attribute, value)
end

local function getCapabilities(capability): any
	return capabilities[capability]
end

local function InputBegan(input: InputObject, gameProcessedEvent)
	if not gameProcessedEvent and input == Enum.KeyCode.G and getCapabilities("Frost") ~= 0 then
		AttackRE:FireServer("Frost", mouse, getCapabilities("Frost"), "Frost")
	end
end

UserInputService.InputBegan:Connect(InputBegan)
