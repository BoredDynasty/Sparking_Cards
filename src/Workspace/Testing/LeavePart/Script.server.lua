local clickDetect = script.Parent.ClickDetector
local players = game.Players

local CurrentCam = workspace.CurrentCamera

local queuePart = script.Parent.Parent.QueuePart

local queuePartDescendants = queuePart.Details:GetDescendants()

clickDetect.MouseClick:Connect(function(playerWhoClicked: Player)  
--[[	local character = playerWhoClicked.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.RootPart.CFrame = CFrame.new(Vector3.new(100.001, 10.001, 100.001))
		end
	end
	--]]

	if playerWhoClicked.Character then
		playerWhoClicked.Character:PivotTo(script.Parent.CFrame)
		-- Added Player Walkspeed
		
		
	end

	local humanoid = playerWhoClicked.Character:WaitForChild("Humanoid")
	if humanoid then
		print("AddedPlayerWalkspeed(Removed_Queue, (" .. script.Parent.Parent.Name .. ")")
		humanoid.WalkSpeed = 14
	end
	
	--------- Tween
	
	local TInfo = TweenInfo.new(0.3, 
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut)
	
	local tween = game:GetService("TweenService")

	tween:Create(queuePart, TInfo, {Transparency = 0.5}):Play()
	
	for _, descendant in pairs(queuePartDescendants) do
		if descendant:IsA("Part") then
			tween:Create(descendant, TInfo, {Transparency = 0.5}):Play()
		end
	end
	
	
	-- Camera Manipulation
	--[[
	CurrentCam.CameraType = Enum.CameraType.Custom
	if CurrentCam.CameraType ~= Enum.CameraType.Custom then
		warn("CurrentCam is not set to Roblox Default! Changing now...")
		-- repeat until it's set
		repeat wait() CurrentCam.CameraType = Enum.CameraType.Custom until CurrentCam.CameraType == Enum.CameraType.Custom
	end
	

	-- play the animation
	--[[local animator = humanoid:FindFirstChild("Animator")
	if animator then
		local animation = Instance.new("Animation")
		animation.AnimationId = "rbxassetid://14248410946"
		local animationTrack = animator:LoadAnimation(animation)
		animationTrack:Play()
		animationTrack.Stopped:Wait()
	end
	--]]
	CurrentCam.CameraType = Enum.CameraType.Custom
end)