-- https://devforum.roblox.com/t/cameraservice-a-new-camera-for-a-new-roblox/1988655

local CameraService = require(game.ReplicatedStorage.CameraService)

local Bindable = game.ReplicatedStorage.Event

local CameraPart

local CinematicCameraParams = {
	Smoothness = 7,
	CharacterVisibility = "All",
	MinZoom = 10,
	MaxZoon = 10.001,
	AlignChar = false,
	Offset = CFrame.new(),
	LockMouse = false,
	BodyFollow = false
}

Bindable.Event:Connect(function(playerWhoClicked, CamPart) 
	CameraPart = CamPart
	CameraService:SetCameraHost(CameraPart)
end)

--CameraService:CreateNewCameraView("Cinematic", CinematicCameraParams)
--CameraService:SetCameraView("Cinematic")
--CameraService:ChangeFOV(90, false)

