--!strict

local MainFrame = script.Parent.Parent
local TextLabel = MainFrame.DialogueText
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvent = ReplicatedStorage.RemoteEvents.NewDialogue

local Tick = script.dialogue

local CurrentCamera = game.Workspace.CurrentCamera

local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(
	0.2,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

local CutsceneTInfo = TweenInfo.new(
	2,
	Enum.EasingStyle.Sine
)

local function ShowFrame()
	TweenService:Create(MainFrame, TweenParams, {Position = UDim2.new(0, 0, 0.9, 0)}):Play()
end

local function HideFrame()
	TweenService:Create(MainFrame, TweenParams, {Position = UDim2.new(0, 0, 1.5, 0)}):Play()
end

local function Cleanup()
	TextLabel.Text = ""
end


local function TypeWriter(DisplayedText)
	local Text: string = DisplayedText
	for i = 1, #Text do
		TextLabel.Text = string.sub(DisplayedText, 1, i)
		wait(0.05)
	end
end

RemoteEvent.OnClientEvent:Connect(function(Text: string, WaitTime: number, Camera: boolean, CameraPosition: CFrame)
	task.wait(0.1)
	TextLabel.Text = tostring(Text)
	ShowFrame()
	task.wait(0.2)
	
	if Camera == true then
		repeat wait()
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
		until CurrentCamera.CameraType == Enum.CameraType.Scriptable
		
		CurrentCamera.CFrame = CameraPosition
		CurrentCamera.CameraType = Enum.CameraType.Custom
	elseif Camera == false then
		CurrentCamera.CameraType = Enum.CameraType.Custom	
	end
	
	task.wait(tonumber(WaitTime))
	HideFrame()
	task.wait(1)
	Cleanup()
end)