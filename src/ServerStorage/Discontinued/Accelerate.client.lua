local TS = game:GetService("TweenService")
local char = script.Parent
local hum = char:WaitForChild("Humanoid")

local originalspeed = script:WaitForChild("originalspeed").Value
local maxspeed = script:WaitForChild("maxspeed").Value
local speeduptime = script:WaitForChild("speeduptime").Value

local runanim = hum:FindFirstChild("Animator"):LoadAnimation(script.runanim)

local speedup = TS:Create(hum, TweenInfo.new(speeduptime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {WalkSpeed = maxspeed})

hum.Running:Connect(function(spd)
	if spd > originalspeed - 1 then

		speedup:Play()

		if not runanim.IsPlaying then 
			runanim:Play(speeduptime)
			print("playing run")
		end

		for i, v in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
			if v.Name == "WalkAnim" then
				if script.runanim.AnimationId ~= "rbxassetid://0" then
					v:Stop(speeduptime)
				end
			end
		end
	elseif spd <= 0 then
		speedup:Cancel()
		runanim:stop()

		hum.WalkSpeed = originalspeed

	end
end)