--!strict
-- // Services
local CollectionService = game:GetService("CollectionService")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VFXClass = require(ReplicatedStorage.Classes.VFXClass)

-- // Variables

local Particle = script.Parent.ChargeVFX
local AnimationStart = "rbxassetid://18900211493"

local Debounce = false

Players.PlayerAdded:Wait()

local CanUse = Instance.new("BoolValue", Players.LocalPlayer)
local KeyValue = Instance.new("StringValue", Players.LocalPlayer)

KeyValue.Value = "C"
KeyValue.Name = "Charge_KEY_Ability"
CanUse.Name = "CanUseAbilities"
CanUse.Value = true

-- // Functions

VFXClass.StartListening(Players.LocalPlayer)

local Character = Players.LocalPlayer.Character or Players.LocalPlayer.ChracterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

HumanoidRootPart.Touched:Connect(function(otherPart)
	local MainTag = "AbilitiesDisabled"
	local tag = CollectionService:GetTagged(MainTag)
	if CollectionService:HasTag(otherPart, MainTag) then
		CanUse.Value = false
	else
		CanUse.Value = true
	end
end)
