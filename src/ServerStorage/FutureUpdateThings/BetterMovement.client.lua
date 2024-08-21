

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Humanoid = Player.Character:WaitForChild("Humanoid")
local bobbing = nil
local func1 = 0
local func2 = 0
local func3 = 0
local func4 = 0
local val = 0
local val2 = 0
local int = 5
local int2 = 5
local vect3 = Vector3.new()



UserInputService.MouseIconEnabled = true

function lerp(a, b, c)
	return a + (b - a) * c
end

bobbing = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
	deltaTime = deltaTime * 30
	if Humanoid.Health <= 0 then
		bobbing:Disconnect()
		return
	end
	local rootMagnitude = Humanoid.RootPart and Vector3.new(Humanoid.RootPart.Velocity.X, 0, Humanoid.RootPart.Velocity.Z).Magnitude or 0
	local calcRootMagnitude = math.min(rootMagnitude, 25)
	if deltaTime > 1.5 then
		func1 = 0
		func2 = 0
	else
		func1 = lerp(func1, math.cos(tick() * 0.5 * math.random(5, 7.5)) * (math.random(2.5, 10) / 100) * deltaTime, 0.05 * deltaTime)
		func2 = lerp(func2, math.cos(tick() * 0.5 * math.random(2.5, 5)) * (math.random(1, 5) / 100) * deltaTime, 0.05 * deltaTime)
	end
	Camera.CFrame = Camera.CFrame * (CFrame.fromEulerAnglesXYZ(0, 0, math.rad(func3)) * CFrame.fromEulerAnglesXYZ(math.rad(func4 * deltaTime), math.rad(val * deltaTime), val2) * CFrame.Angles(0, 0, math.rad(func4 * deltaTime * (calcRootMagnitude / 5))) * CFrame.fromEulerAnglesXYZ(math.rad(func1), math.rad(func2), math.rad(func2 * 10)))
	val2 = math.clamp(lerp(val2, -Camera.CFrame:VectorToObjectSpace((Humanoid.RootPart and Humanoid.RootPart.Velocity or Vector3.new()) / math.max(Humanoid.WalkSpeed, 0.01)).X * 0.04, 0.1 * deltaTime), -0.12, 0.1)
	func3 = lerp(func3, math.clamp(UserInputService:GetMouseDelta().X, -2.5, 2.5), 0.25 * deltaTime)
	func4 = lerp(func4, math.sin(tick() * int) / 5 * math.min(1, int2 / 10), 0.25 * deltaTime)
	if rootMagnitude > 1 then
		val = lerp(val, math.cos(tick() * 0.5 * math.floor(int)) * (int / 200), 0.25 * deltaTime)
	else
		val = lerp(val, 0, 0.05 * deltaTime)
	end
	if rootMagnitude > 6 then
		int = 10
		int2 = 9
	elseif rootMagnitude > 0.1 then
		int = 6
		int2 = 7
	else
		int2 = 0
	end
	Player.CameraMaxZoomDistance = 50
	Player.CameraMinZoomDistance = 0.5
	vect3 = lerp(vect3, Camera.CFrame.LookVector, 0.125 * deltaTime)
end)
