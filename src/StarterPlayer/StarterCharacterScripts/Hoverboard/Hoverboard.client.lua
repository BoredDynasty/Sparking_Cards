--!nonstrict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local character: Model = script.Parent.Parent
local humanoid: Humanoid = character:WaitForChild("Humanoid")
local AnimationInstance = Instance.new("Animation", script)
AnimationInstance.Name = "Anim"
AnimationInstance.AnimationId = "rbxassetid://18668564742"
local animationTrack = humanoid:WaitForChild("Animator")
animationTrack:LoadAnimation(script:WaitForChild("Anim"))

local Connection
local seat: VehicleSeat
local attachment: Attachment
local vectorForce: VectorForce
local orientation
local alignOrientation: AlignOrientation = nil
local minimumThrust = 600
local thrust = 2000

local RaycastParam
local RayOffset = Vector3.new(0, -8, 0)
local rayVelocity = 0.2
local RayPart = Instance.new("Part", workspace)
RayPart.Anchored = true
RayPart.CanCollide = false
RayPart.CanQuery = false
RayPart.CanTouch = false
RayPart.Shape = Enum.PartType.Ball
RayPart.Size = Vector3.one
RayPart.Name = "RayPart"

local function loop(deltaTime)
	local RayTarget = seat.Position + RayOffset + seat.AssemblyLinearVelocity * rayVelocity
	local result = workspace:Raycast(seat.Position, RayTarget - seat.Position, RaycastParam)
	if result == nil then
		vectorForce.Force = Vector3.new(0, minimumThrust, 0)
		RayPart.BrickColor = BrickColor.Green()
		RayPart.Position = RayTarget
	else
		local magnitude = (result.Position - RayTarget).Magnitude
		vectorForce.Force = Vector3.new(0, minimumThrust + magnitude * thrust, 0)
		RayPart.BrickColor = BrickColor.Red()
		RayPart.Position = result.Position
	end
	orientation *= CFrame.fromOrientation(0, -seat.SteerFloat * seat.TurnSpeed * deltaTime, 0)
	local tiltOrientation = CFrame.fromOrientation(-seat.ThrottleFloat * seat.Torque, 0, -seat.SteerFloat * seat.Torque)
	alignOrientation.CFrame = orientation * tiltOrientation
end

local function seated(active, currentSeat)
	if active == false then
		if Connection == nil then
			return
		end
		Connection:Disconnect()
		Connection = nil
		attachment:Destroy()
		vectorForce:Destroy()
		alignOrientation:Destroy()
		animationTrack:Stop()
	elseif currentSeat.Name == "Hoverboard" then
		seat = currentSeat
		attachment = Instance.new("Attachment", seat)
		vectorForce = Instance.new("VectorForce", seat)
		vectorForce.Force = Vector3.zero
		vectorForce.ApplyAtCenterOfMass = true
		vectorForce.Attachment0 = attachment
		orientation = CFrame.fromMatrix(Vector3.zero, seat.CFrame.LookVector:Cross(Vector3.yAxis), Vector3.yAxis)
		alignOrientation = Instance.new("AlignOrientation", seat)
		alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
		alignOrientation.CFrame = orientation
		alignOrientation.Attachment0 = attachment
		attachment.Parent = seat
		RaycastParam = RaycastParams.new()
		RaycastParam.FilterType = Enum.RaycastFilterType.Exclude
		RaycastParam.FilterDescendantsInstances = { character, seat:FindFirstAncestorOfClass("Model") }
		Connection = RunService.PostSimulation:Connect(loop)
		animationTrack:Play()
	end
end

humanoid.Seated:Connect(function(active, currentSeatPart)
	seated(active, currentSeatPart)
end)
