--!strict
local Class = {}
Class.__index = Class
Class.soundTypes = { "Click", "Cha - Ching", "Error", "Question" }
Class.Warning = {
	"Make a Folder in ReplicatedStorage. Add a tag called 'UISoundsFolder' with an attribute of 'SoundFolder.'", 
	"The Color you input witin the tuple must be Red or Green.",
	"The value of the Blur Effects must be a boolean."
}

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Camera = game.Workspace:WaitForChild("Camera")
local Blur = Lighting.Blur
Class.DepthOfFieldEffect = Instance.new("DepthOfFieldEffect", Lighting)
if not Blur then
	Instance.new("BlurEffect", Lighting)
end
Class.TweenTime = 0.2

function Class.BlurEffect(value: boolean)
	if value == true then
		TweenService:Create(Blur, TweenInfo.new(Class.TweenTime), { Size = 10 }):Play()
		TweenService:Create(Camera, TweenInfo.new(Class.TweenTime), { FieldOfView = 60 }):Play()
	else
		TweenService:Create(Blur, TweenInfo.new(Class.TweenTime), { Size = 0 }):Play()
		TweenService:Create(Camera, TweenInfo.new(Class.TweenTime), { FieldOfView = 70 }):Play()
	end
end

function Class.AnimateGradient(gradient: UIGradient, value: boolean, loop: boolean, delay: number) -- it goes on forever hehe
	if value == true then
		local tween
		tween = TweenService:Create(
			gradient,
			TweenInfo.new(Class.TweenTime, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, math.huge, loop, delay)
		)
		tween:Play()
	end
end

function Class.TypewriterEffect(DisplayedText, TextLabel)
	local Text: string = DisplayedText
	for i = 1, #Text do
		TextLabel.Text = string.sub(DisplayedText, 1, i)
		task.wait(0.05)
	end
end

function Class.FrameMovingEffect(type, speed, frame)
	if not speed then
		speed = 2
	end
	-- A simple parametric equation of a circle
	-- centered at (0.5, 0.5) with radius (0.5)
	local function circle(t)
		return 0.5 + math.cos(t) * 0.5, 0.5 + math.sin(t) * 0.5
	end
	local currentTime = 0
	local function onRenderStep(deltaTime: number)
		-- Update the current time
		currentTime = currentTime + deltaTime * speed
		-- ...and the frame's position
		local x, y = circle(currentTime)
		frame.Position = UDim2.new(x, 0, y, 0)
	end
	RunService:BindToRenderStep("Frame_Circle", Enum.RenderPriority.Last.Value, onRenderStep)
	return "Frame_Circle"
end

function Class.UnbindFromRenderStep(unbind: string)
	RunService:UnbindFromRenderStep(unbind)
end

function Class.Sound(soundType, soundEffect) -- Used Mainly for GUI Effects.
	local SoundsFolder = ReplicatedStorage.UISounds or ReplicatedStorage.Sounds -- Add A UISounds folder or configuration instance. and attach sounds to em.

	local function playSound(sound)
		local newSound = SoundsFolder[sound]
		newSound = newSound:Clone()
		newSound.Parent = ReplicatedStorage
		newSound:SetAttribute(script.Name)
		
		if soundEffect then
			Instance.new(soundEffect, newSound)
		end
		
		Debris:AddItem(newSound, newSound.TimeLength)
		newSound:Play()
	end
	
	playSound(soundType)
end

function Class.changeColor(color: string, frame)
	local newColor
	if color == "Green" then
		newColor = Color3.fromHex("#55ff7f")
	elseif color == "Red" then 
		newColor = Color3.fromHex("#ff4e41")
	end
	
	task.wait(1)
	if frame:IsA("Frame") then
		TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = newColor}):Play()
	elseif frame:IsA("ImageLabel") then
		TweenService:Create(frame, TweenInfo.new(0.1), {ImageColor3 = newColor}):Play()
	end
end

function Class.ClickEffect(object: GuiObject)
	if not object then return end
	
	local Frame = Instance.new("Frame", object)
	Frame.Size = UDim2.new(0, 1, 0, 1)
	Frame.Position = object.Position
	Frame.ZIndex = object.ZIndex + 1
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = object.BackgroundColor3
	local UICorner = Instance.new("UICorner", Frame)
	UICorner.CornerRadius = object:FindFirstChildOfClass("UICorner").CornerRadius

	local tween = TweenService:Create(Frame, TweenInfo.new(Class.TweenTime / 0.5), {
		Size = UDim2.new(
			0, 
			object.Size.X.Offset, 
			0, 
			object.Size.Y.Offset)})
	tween:Play()
	if tween.PlaybackState == Enum.PlaybackState.Completed then
		Frame:Destroy()
	end
		--[[
	for index, buttons in pairs(object:GetDescendants()) do
		if buttons:IsA("GuiButton") then
			buttons.MouseButton1Down:Connect(function()  
				if buttons:FindFirstChildOfClass("UIStroke") and UIStroke then
					buttons:FindFirstChildOfClass("UIStroke").Color = Color3.new(0.333333, 1, 0.498039)
				end
			end)
		end
	end	
	]]
end

return Class
