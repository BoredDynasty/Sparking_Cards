--local camera = game.Workspace.CurrentCamera
local player = game.Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character.HumanoidRootPart
local car = script:WaitForChild("Car").Value
local stats = car:WaitForChild("Configurations")
local Raycast = require(car.CarScript.RaycastModule)

--local cameraType = Enum.CameraType.Follow

local movement = Vector2.new()
local gamepadDeadzone = 0.14

car.DriveSeat.Changed:connect(function(property)
	if property == "Steer" then
		movement = Vector2.new(car.DriveSeat.Steer, movement.Y)
	elseif property == "Throttle" then
		movement = Vector2.new(movement.X, car.DriveSeat.Throttle)
	end
end)

-- Input begin
--game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameProcessedEvent)
--	if not gameProcessedEvent then
--		if inputObject.KeyCode == Enum.KeyCode.W then
--			movement = Vector2.new(movement.X, 1)
--		elseif inputObject.KeyCode == Enum.KeyCode.A then
--			movement = Vector2.new(-1, movement.Y)
--		elseif inputObject.KeyCode == Enum.KeyCode.S then
--			movement = Vector2.new(movement.X, -1)
--		elseif inputObject.KeyCode == Enum.KeyCode.D then
--			movement = Vector2.new(1, movement.Y)
--		end
--	end
--end)
--
--game:GetService("UserInputService").InputChanged:connect(function(inputObject, gameProcessedEvent)
--	--if not gameProcessedEvent then
--		if inputObject.KeyCode == Enum.KeyCode.Thumbstick1 then
--			--Gamepad support because yay
--			if inputObject.Position.magnitude >= gamepadDeadzone then
--				movement = Vector2.new(movement.X, inputObject.Position.Y)
--			else
--				movement = Vector2.new(movement.X, 0)
--			end
--		elseif inputObject.KeyCode == Enum.KeyCode.Thumbstick2 then
--			if inputObject.Position.magnitude >= gamepadDeadzone then
--				movement = Vector2.new(inputObject.Position.X, movement.Y)
--			else
--				movement = Vector2.new(0, movement.Y)
--			end
--		end
--	--end
--end)
--
---- Input end
--game:GetService("UserInputService").InputEnded:connect(function(inputObject, gameProcessedEvent)
--	if inputObject.KeyCode == Enum.KeyCode.W then
--		if movement.Y == 1 then
--			movement = Vector2.new(movement.X, 0)
--		end
--	elseif inputObject.KeyCode == Enum.KeyCode.A then
--		if movement.X == -1 then
--			movement = Vector2.new(0, movement.Y)
--		end
--	elseif inputObject.KeyCode == Enum.KeyCode.S then
--		if movement.Y == -1 then
--			movement = Vector2.new(movement.X, 0)
--		end
--	elseif inputObject.KeyCode == Enum.KeyCode.D then
--		if movement.X == 1 then
--			movement = Vector2.new(0, movement.Y)
--		end
--	end
--end)

local force = 0
local damping = 0

local mass = 0

for i, v in pairs(car:GetChildren()) do
	if v:IsA("BasePart") then
		mass = mass + (v:GetMass() * 196.2)
	end
end

force = mass * stats.Suspension.Value
damping = force / stats.Bounce.Value

local bodyVelocity = Instance.new("BodyVelocity", car.Chassis)
bodyVelocity.velocity = Vector3.new(0, 0, 0)
bodyVelocity.maxForce = Vector3.new(0, 0, 0)

local bodyAngularVelocity = Instance.new("BodyAngularVelocity", car.Chassis)
bodyAngularVelocity.angularvelocity = Vector3.new(0, 0, 0)
bodyAngularVelocity.maxTorque = Vector3.new(0, 0, 0)

local rotation = 0

local function UpdateThruster(thruster)
	--Make sure we have a bodythrust to move the wheel
	local bodyThrust = thruster:FindFirstChild("BodyThrust")
	if not bodyThrust then
		bodyThrust = Instance.new("BodyThrust", thruster)
	end
	--Do some raycasting to get the height of the wheel
	local hit, position = Raycast.new(thruster.Position, thruster.CFrame:vectorToWorldSpace(Vector3.new(0, -1, 0)) * stats.Height.Value)
	local thrusterHeight = (position - thruster.Position).magnitude
	if hit and hit.CanCollide then
		--If we're on the ground, apply some forces to push the wheel up
		bodyThrust.force = Vector3.new(0, ((stats.Height.Value - thrusterHeight)^2) * (force / stats.Height.Value^2), 0)
		local thrusterDamping = thruster.CFrame:toObjectSpace(CFrame.new(thruster.Velocity + thruster.Position)).p * damping
		bodyThrust.force = bodyThrust.force - Vector3.new(0, thrusterDamping.Y, 0)
	else
		bodyThrust.force = Vector3.new(0, 0, 0)
	end
	
	--Wheels
	local wheelWeld = thruster:FindFirstChild("WheelWeld")
	if wheelWeld then
		wheelWeld.C0 = CFrame.new(0, -math.min(thrusterHeight, stats.Height.Value * 0.8) + (wheelWeld.Part1.Size.Y / 2), 0)
		-- Wheel turning
		local offset = car.Chassis.CFrame:inverse() * thruster.CFrame
		local speed = car.Chassis.CFrame:vectorToObjectSpace(car.Chassis.Velocity)
		if offset.Z < 0 then
			local direction = 1
			if speed.Z > 0 then
				direction = -1
			end
			wheelWeld.C0 = wheelWeld.C0 * CFrame.Angles(0, (car.Chassis.RotVelocity.Y / 2) * direction, 0)
		end
		wheelWeld.C0 = wheelWeld.C0 * CFrame.Angles(rotation, 0, 0)
	end
end

--A simple function to check if the car is grounded
local function IsGrounded()
	local hit, position = Raycast.new((car.Chassis.CFrame * CFrame.new(0, 0, (car.Chassis.Size.Z / 2) - 1)).p, car.Chassis.CFrame:vectorToWorldSpace(Vector3.new(0, -1, 0)) * (stats.Height.Value + 0.2))
	if hit and hit.CanCollide then
		return(true)
	end
	return(false)
end

--local oldCameraType = camera.CameraType
--camera.CameraType = cameraType

--spawn(function()
	while game:GetService("RunService").Heartbeat:wait() and car:FindFirstChild("DriveSeat") and character.Humanoid.SeatPart == car.DriveSeat do
		--game:GetService("RunService").RenderStepped:wait()
		if IsGrounded() then
			if movement.Y ~= 0 then
				local velocity = humanoidRootPart.CFrame.lookVector * movement.Y * stats.Speed.Value
				humanoidRootPart.Velocity = humanoidRootPart.Velocity:Lerp(velocity, 0.1)
				bodyVelocity.maxForce = Vector3.new(0, 0, 0)
			else
				bodyVelocity.maxForce = Vector3.new(mass / 2, mass / 4, mass / 2)
			end
			local rotVelocity = humanoidRootPart.CFrame:vectorToWorldSpace(Vector3.new(movement.Y * stats.Speed.Value / 50, 0, -humanoidRootPart.RotVelocity.Y * 5 * movement.Y))
			local speed = -humanoidRootPart.CFrame:vectorToObjectSpace(humanoidRootPart.Velocity).unit.Z
			rotation = rotation + math.rad((-stats.Speed.Value / 5) * movement.Y)
			if math.abs(speed) > 0.1 then
				rotVelocity = rotVelocity + humanoidRootPart.CFrame:vectorToWorldSpace((Vector3.new(0, -movement.X * speed * stats.TurnSpeed.Value, 0)))
				bodyAngularVelocity.maxTorque = Vector3.new(0, 0, 0)
			else
				bodyAngularVelocity.maxTorque = Vector3.new(mass / 4, mass / 2, mass / 4)
			end
			humanoidRootPart.RotVelocity = humanoidRootPart.RotVelocity:Lerp(rotVelocity, 0.1)
			
			--bodyVelocity.maxForce = Vector3.new(mass / 3, mass / 6, mass / 3)
			--bodyAngularVelocity.maxTorque = Vector3.new(mass / 6, mass / 3, mass / 6)
		else
			bodyVelocity.maxForce = Vector3.new(0, 0, 0)
			bodyAngularVelocity.maxTorque = Vector3.new(0, 0, 0)
		end
		
		for i, part in pairs(car:GetChildren()) do
			if part.Name == "Thruster" then
				UpdateThruster(part)
			end
		end
	end
	for i, v in pairs(car:GetChildren()) do
		if v:FindFirstChild("BodyThrust") then
			v.BodyThrust:Destroy()
		end
	end
	bodyVelocity:Destroy()
	bodyAngularVelocity:Destroy()
	--camera.CameraType = oldCameraType
	script:Destroy()
--end)