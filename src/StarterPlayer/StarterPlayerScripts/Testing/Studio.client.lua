--!strict

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MessagingService = game:GetService("MessagingService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)
local MathClass = require(ReplicatedStorage.Classes.MathClass)
local PostClass = require(ReplicatedStorage.Classes.PostClass)

local SendBenchmarks: UnreliableRemoteEvent = ReplicatedStorage:WaitForChild("Benchmarks")

local Debounce = false

if not RunService:IsStudio() then
	script:Destroy()
end

task.wait(10)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	if Debounce == false then
		Debounce = true
		if input.KeyCode == Enum.KeyCode.Zero then
			SendBenchmarks:FireServer()
		end
		task.wait(9)
		Debounce = false
	end
end)
