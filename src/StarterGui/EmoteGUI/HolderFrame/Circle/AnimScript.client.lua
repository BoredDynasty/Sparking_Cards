local frame = script.Parent
local user = game.Players.LocalPlayer
repeat wait()
until user.Character 

local char = user.Character
local humanoid = char:WaitForChild("Humanoid")
local anim

function playanim(AnimationID)
	if char ~=nil and humanoid ~=nil then
		local AnimationID= "rbxassetid://" .. tostring(AnimationID)
		local oldanim=char:FindFirstChild("LocalAnimation")
		humanoid.WalkSpeed = 0
		if anim ~= nil then
			anim:Stop()
		end
		
		if oldanim ~= nil then
			if oldanim.AnimationId == AnimationID then
				oldanim:Destroy()
				humanoid.WalkSpeed = 14
				return
			end
			oldanim:Destroy()
		end
		
		local animation=Instance.new("Animation", char)
		animation.Name="LocalAnimation"
		animation.AnimationId = AnimationID
		anim = humanoid:LoadAnimation(animation)
		anim:Play()
		humanoid.WalkSpeed = 0
	end
end

local b1 = frame.f1
local b2 = frame.f2
local b3 = frame.f3
local b4 = frame.f4
local b5 = frame.f5
local b6 = frame.f6
local b7 = frame.f7
local b8 = frame.f8
-- local b9 = frame.f9

b1.MouseButton1Down:connect(function() 
	playanim(b1.AnimID.Value) 
end)

b2.MouseButton1Down:connect(function() 
	playanim(b2.AnimID.Value) 
end)

b3.MouseButton1Down:connect(function() 
	playanim(b3.AnimID.Value) 
end)

b4.MouseButton1Down:connect(function() 
	playanim(b4.AnimID.Value) 
end)

b5.MouseButton1Down:connect(function() 
	playanim(b5.AnimID.Value) 
end)

b6.MouseButton1Down:connect(function() 
	playanim(b6.AnimID.Value) 
end)

b7.MouseButton1Down:connect(function() 
	playanim(b7.AnimID.Value) 
end)

b8.MouseButton1Down:connect(function() 
	playanim(b8.AnimID.Value) 
end)
--[[
b9.MouseButton1Down:connect(function() 
	playanim(b9.AnimID.Value) 
end)

--]]