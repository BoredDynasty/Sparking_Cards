local UIS = game:GetService('UserInputService')
local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local CurrentCamera = workspace.CurrentCamera

local slideAnim = Instance.new('Animation')
slideAnim.AnimationId = 'rbxassetid://6448644261'

local slide = Instance.new("BodyVelocity")
local keybind = Enum.KeyCode.LeftControl
local canslide = true

local playAnim = char:WaitForChild("Humanoid"):LoadAnimation(slideAnim)

UIS.InputBegan:Connect(function(input,gameprocessed)
	if gameprocessed then return end
	if not canslide then return end
	
	if input.KeyCode == keybind then
		canslide = false
		
		playAnim:Play()
		
		char.HumanoidRootPart.CanCollide = false

		local Head = char:FindFirstChild('Head')
		Head.CanCollide = false
		
		
		if char.Humanoid:GetState(Enum.HumanoidStateType.Jumping) or (Enum.HumanoidStateType.Freefall) then
			slide.MaxForce = Vector3.new(0,0,0)
			slide.Velocity = Vector3.new(0,0,0)
		end
		slide.Parent = char.Humanoid.RootPart
		slide.MaxForce = Vector3.new(1 * 10000,0,1 * 10000)
		Head.CanCollide = false
		
		local tween = game:GetService("TweenService"):Create(char.Humanoid, TweenInfo.new(1), {CameraOffset = Vector3.new(0,-2,0)})

		tween:Play()
		
		while (canslide ~= true) do
			slide.Velocity = char.HumanoidRootPart.CFrame.lookVector * 3
			wait()
		end
		
	end
end)
UIS.InputEnded:Connect(function(input,gameprocessed)
	if gameprocessed then return end
	
	if input.KeyCode == keybind then
		for count = 1, 3 do
			wait(0.01)
			slide.Velocity *= 0.01
		end
		playAnim:Stop()
		slide.Parent = workspace
		slide.MaxForce = Vector3.new(0,0,0)
		canslide = true
		char.HumanoidRootPart.CanCollide = true
		CurrentCamera.CameraSubject = char.Humanoid
		local Head = char:FindFirstChild('Head')
		Head.CanCollide = true
		local tween = game:GetService("TweenService"):Create(char.Humanoid, TweenInfo.new(1), {CameraOffset = Vector3.new(0,0,0)})
		tween:Play()
	end
end)