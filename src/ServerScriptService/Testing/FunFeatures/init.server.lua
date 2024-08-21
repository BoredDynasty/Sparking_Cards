-- This script enables fun features if a player is in a private server, or if theres a single player within the server.

local Players = game:GetService("Players")
local PlayerThreshold = 1

local AllPlayers = #Players:GetPlayers()

if AllPlayers <= PlayerThreshold then

	local Notifier = script.ScreenGui

	local UserInputService = game:GetService("UserInputService")
	local Accelerometer = UserInputService.AccelerometerEnabled

	local GameGravity = workspace.Gravity

	local TweenService = game:GetService("TweenService")
	local TweenParams = TweenInfo.new(
		0.2
	)

	local GetDevice = require(game.ReplicatedStorage.UserInputType)
	local InputType = GetDevice.getInputType()

	local ball = Instance.new("Part")
	if not ball then return end
	ball.Size = Vector3.new(2, 2, 2)
	ball.Anchored = false
	ball.Shape = Enum.PartType.Ball
	ball.Position = Vector3.new(-1642, 241.75, 170)
	ball.Parent = workspace

	local mass = ball:GetMass()
	local gravityForce = ball:WaitForChild("GravityForce", 5)

	local function moveBall(gravity)
		gravityForce.Force = gravity.Position * workspace.Gravity * mass
	end

	if InputType == "Touch" then
		if UserInputService.AccelerometerEnabled then
			UserInputService.DeviceGravityChanged:Connect(moveBall) -- Move the ball across the place!
		end
	end

	UserInputService.TouchSwipe:Connect(function(swipeDirection: Enum.SwipeDirection, numberOfTouches: number, gameProcessedEvent: boolean) 
		if gameProcessedEvent then
			return
		end
		if numberOfTouches == 3 then
			if swipeDirection == Enum.SwipeDirection.Up then
				TweenService:Create(workspace.Gravity, TweenParams, {Value = 400}):Play()
			elseif swipeDirection == Enum.SwipeDirection.Down then
				TweenService:Create(workspace.Gravity, TweenParams, {Value = 196.2}):Play()
			end
		end

		if swipeDirection == Enum.SwipeDirection.Left then -- Move the ball with a simple swipe
			TweenService:Create(ball, TweenParams, {Position = ball.Position + Vector3.new(10, 0, 0)}):Play()
		elseif swipeDirection == Enum.SwipeDirection.Right then
			TweenService:Create(ball, TweenParams, {Position = ball.Position + Vector3.new(-10, 0, 0)}):Play()
		end

	end)

end