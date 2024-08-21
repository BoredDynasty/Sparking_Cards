local clickDetector = script.Parent.ClickDetector

local RunService = game:GetService("RunService")

local Remote = game:GetService("ReplicatedStorage").RemoteEvents.NewDialogue


local Camera = script.Parent:GetAttribute("Camera")
local DialogueMessage = script.Parent:GetAttribute("DialogueMessage")
local WaitTime = script.Parent:GetAttribute("WaitTime")


local startCFrame = script.Parent.Parent.CFrame
local ways = {
	push1 = startCFrame * CFrame.new(-7, 0, 0)
}

local part = script.Parent.Parent

local lerpTime = 1.5
local startTime = tick()
local runningTime = 3
local lerp

local db = false

script.Parent.Touched:Connect(function(hit)
	if db == false then
		db = true
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")

		Remote:FireAllClients(DialogueMessage, WaitTime, Camera)
		print("Dialogue Request Processed")
	end
	task.wait(5)
	db = false
end)
