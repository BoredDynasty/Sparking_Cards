--[=[
    @class Camera
--]=]
local Camera = {}
Camera.__index = Camera

-- From https://github.com/BoredDynasty/Code_Testing/blob/main/Luau/LuauCameraSystem/Camera.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local self

export type Camera = {
	self: {},
}

--[=[
    @function Constructor
        @param options table
        @param player Player
		@return any
--]=]
function Camera.Constructor(player): Camera
	self = setmetatable({}, Camera)

	self.currentCamera = workspace.CurrentCamera
	self.connection = nil
	self.player = player
	self.defaultCamera = {
		["FieldOfView"] = 70,
		["CameraType"] = Enum.CameraType.Custom,
		["Rotation"] = math.rad(0),
	}
	self.modifiedCamera = {
		["FieldOfView"] = 70,
		["CameraType"] = Enum.CameraType.Scriptable,
		["Rotation"] = math.rad(0),
	}

	for property, _ in self.currentCamera do
		if table.find(self.currentCamera, self.modifiedCamera) then
			property = self.defaultCamera[property]
		end
	end

	return self
end

--[=[
    @function SetAngle
        @param x table
		@return RBXScriptConnection?
--]=]
function Camera:SetAngle(x: { number }): RBXScriptConnection
	if self.connection == nil then
		self.connection = RunService.RenderStepped:Connect(function()
			self.currentCamera.CFrame.Rotation = math.rad(x)
		end)
	elseif self.connection == RunService.RenderStepped then
		self.connection:Disconnect()
	end

	return self.connection
end

--[=[
    @function SetLook
        @param x any
        @return RBXScriptConnection
--]=]
function Camera:SetLook(x: any): RBXScriptConnection
	if self.connection == nil then
		self.connection = RunService.RenderStepped:Connect(function()
			self.currentCamera.CFrame.LookVector = Vector3.new(x[1], x[2], x[3])
		end)
	elseif self.connection == RunService.RenderStepped then
		self.connection:Disconnect()
	end

	return self.connection
end

--[=[
    @function Cinematic
        @param keypoints table CFrame?
        @param Tween TweenInfo
        @return any?
--]=]
function Camera:Cinematic(keypoints: { CFrame? }, Tween: TweenInfo)
	if self.connection == nil then
		self.connection = "Cinematic"
		for i, coordinate: CFrame? in keypoints do
			TweenService:Create(self.currentCamera, Tween, { CFrame = coordinate }):Play()
			task.wait(2)
			next(keypoints, coordinate)
		end
	end

	return self.connection
end

--[=[
    @function Restore
        @tag Restores the ``CurrentCamera``'s default properties.
--]=]
function Camera:Restore()
	for property, _ in self.currentCamera do
		if table.find(self.currentCamera, self.defaultCamera) then
			property = self.defaultCamera[property]
		end
	end
end

return Camera
