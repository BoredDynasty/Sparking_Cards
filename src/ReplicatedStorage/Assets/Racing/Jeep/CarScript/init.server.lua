--Scripted by DermonDarble

local car = script.Parent
local stats = car.Configurations
local Raycast = require(script.RaycastModule)

local mass = 0

for i, v in pairs(car:GetChildren()) do
	if v:IsA("BasePart") then
		mass = mass + (v:GetMass() * 196.2)
	end
end

local bodyPosition = car.Chassis.BodyPosition
local bodyGyro = car.Chassis.BodyGyro

--local bodyPosition = Instance.new("BodyPosition", car.Chassis)
--bodyPosition.MaxForce = Vector3.new()
--local bodyGyro = Instance.new("BodyGyro", car.Chassis)
--bodyGyro.MaxTorque = Vector3.new()

local function UpdateThruster(thruster)
	-- Raycasting
	local hit, position = Raycast.new(thruster.Position, thruster.CFrame:vectorToWorldSpace(Vector3.new(0, -1, 0)) * stats.Height.Value) --game.Workspace:FindPartOnRay(ray, car)
	local thrusterHeight = (position - thruster.Position).magnitude
	
	-- Wheel
	local wheelWeld = thruster:FindFirstChild("WheelWeld")
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
	
	-- Particles
	if hit and thruster.Velocity.magnitude >= 5 then
		wheelWeld.Part1.ParticleEmitter.Enabled = true
	else
		wheelWeld.Part1.ParticleEmitter.Enabled = false
	end
end

car.DriveSeat.Changed:connect(function(property)
	if property == "Occupant" then
		if car.DriveSeat.Occupant then
			car.EngineBlock.Running.Pitch = 1
			car.EngineBlock.Running:Play()
			local player = game.Players:GetPlayerFromCharacter(car.DriveSeat.Occupant.Parent)
			if player then
				car.DriveSeat:SetNetworkOwner(player)
				local localCarScript = script.LocalCarScript:Clone()
				localCarScript.Parent = player.PlayerGui
				localCarScript.Car.Value = car
				localCarScript.Disabled = false
			end
		else
			car.EngineBlock.Running:Stop()
		end
	end
end)

--spawn(function()
	while true do
		game:GetService("RunService").Stepped:wait()
		for i, part in pairs(car:GetChildren()) do
			if part.Name == "Thruster" then
				UpdateThruster(part)
			end
		end
		if car.DriveSeat.Occupant then
			local ratio = car.DriveSeat.Velocity.magnitude / stats.Speed.Value
			car.EngineBlock.Running.Pitch = 1 + ratio / 4
			bodyPosition.MaxForce = Vector3.new()
			bodyGyro.MaxTorque = Vector3.new()
		else
			local hit, position, normal = Raycast.new(car.Chassis.Position, car.Chassis.CFrame:vectorToWorldSpace(Vector3.new(0, -1, 0)) * stats.Height.Value)
			if hit and hit.CanCollide then
				bodyPosition.MaxForce = Vector3.new(mass / 5, math.huge, mass / 5)
				bodyPosition.Position = (CFrame.new(position, position + normal) * CFrame.new(0, 0, -stats.Height.Value + 0.5)).p
				bodyGyro.MaxTorque = Vector3.new(math.huge, 0, math.huge)
				bodyGyro.CFrame = CFrame.new(position, position + normal) * CFrame.Angles(-math.pi/2, 0, 0)
			else
				bodyPosition.MaxForce = Vector3.new()
				bodyGyro.MaxTorque = Vector3.new()
			end
		end
	end
--end)