--!strict
local Handler = {}

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = game.Workspace:WaitForChild("Camera")
local Blur = Lighting.Blur
local TweenTime = 0.2

function Handler.BlurEffect(value: boolean)
	if value == true then
		TweenService:Create(Blur, TweenInfo.new(TweenTime), { Size = 10 }):Play()
		TweenService:Create(Camera, TweenInfo.new(TweenTime), { FieldOfView = 60 }):Play()
	else
		TweenService:Create(Blur, TweenInfo.new(TweenTime), { Size = 0 }):Play()
		TweenService:Create(Camera, TweenInfo.new(TweenTime), { FieldOfView = 70 }):Play()
	end
end

function Handler.AnimateGradient(gradient: UIGradient, value: boolean, loop: boolean, delay: number) -- it goes on forever lmao
	if value == true then
		local tween
		tween = TweenService:Create(
			gradient,
			TweenInfo.new(TweenTime, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, math.huge, loop, delay)
		)
		tween:Play()
	end
end

return Handler
