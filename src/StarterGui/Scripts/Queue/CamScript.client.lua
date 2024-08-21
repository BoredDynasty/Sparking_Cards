--Place "CamScript" in StarterGUI or the "AutoReplace" script will do it--

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local cam = workspace.CurrentCamera
local com = workspace.CardTable.CameraPart

local QueuePart = workspace.QueuePart
local LeavePart = workspace.LeavePart
local clickDetect = QueuePart.ClickDetector
local LeavepartClickDetect = LeavePart.ClickDetector

local boolean = Instance.new("BoolValue")
boolean.Parent = script
boolean.Name = "CanRepeat"

clickDetect.MouseClick:Connect(function(playerWhoClicked: Player) 
	boolean.Value = true
	
	if boolean.Value == true then
		while wait() do
			cam.CFrame = com.CFrame
		end
	end
end)

if boolean.Value == false then
	cam.CameraType = Enum.CameraType.Custom
	-- Make the cam CFrame normal again.
	cam.CFrame = char.Head.CFrame
end

LeavepartClickDetect.MouseClick:Connect(function() 
	cam.CameraType = Enum.CameraType.Custom
	boolean.Value = false
end)
