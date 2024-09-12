--!strict
local Class = {}
Class.__index = Class
Class.soundTypes = { "Click", "Cha - Ching", "Error", "Question" }

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MathClass = require(ReplicatedStorage.Classes.MathClass)
local VFXClass = require(ReplicatedStorage.Classes.VFXClass)

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

function Class.AnimateGradient(gradient: UIGradient, value: boolean, loop: boolean, delay: number) -- it goes on forever lmao
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

function Class.Sound(soundType, object: GuiObject, soundEffect)
	local SoundsFolder = ReplicatedStorage.Sounds

	local function playSound(type)
		local newSound = SoundsFolder[soundType]
		if newSound then
			newSound.Parent = object
		else
			return
		end
		object:FindFirstChildOfClass("Sound"):Play()

		if soundEffect then
			Instance.new(soundEffect, newSound)
		end
		VFXClass.AddDebris(newSound, newSound.TimeLength) -- hehehehehe~!
	end

	playSound(soundType)
end

return Class
