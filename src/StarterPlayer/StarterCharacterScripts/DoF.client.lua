--[Smart DepthofField Script 2]-->[Nockseh] [Place in StarterPlayer -> StarterCharacterScripts]

--[ --- SETTINGS --- ]--
local blurExtremes	= true	--(true/false, Default true) See Lines 31, 33, 35.
local blurAmount	= .15	--(0.00 - 1.00, Default .15) Out-of-focus objects will be blurred by this amount.
local lerpAmount	= .05	--(0.00 - 1.00, Default .1) Eases into blur using linear interpolation. Lower number, more smoothing. 1 = instant, 0 = infinitely slow
local delayAmount	= 0		--(0.00 - infinity, Default 0) Delay before DoF adjusts to cursor position
--- --- --- --- --- --- ---
local RunService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
mouse = plr:GetMouse()
--create blur instance
local DOF = Instance.new("DepthOfFieldEffect", game.Lighting)
DOF.FarIntensity = blurAmount
DOF.NearIntensity = blurAmount
--lerp function
function lerp(a, b, t)
	return a * (1-t) + (b*t)
end
-- detail loop
RunService.Heartbeat:Connect(function(step)	--activates every frame
	local m = (mouse.Origin.p - mouse.Hit.p)	--grabs ur camera coordinates (x,y,z) & the position ur looking at (x,y,z)
	local d = m.Magnitude	-- converts both (x,y,z) to distance from player
	
	delay(delayAmount, function()
		DOF.FocusDistance = lerp(DOF.FocusDistance, d, lerpAmount)   --sets the focal point to the distance ur looking at
		DOF.InFocusRadius = lerp(DOF.InFocusRadius, d/2, lerpAmount)	--focus area gets smaller the closer you 
		
		if blurExtremes then 
			if d < 3 then
				DOF.FarIntensity = lerp(DOF.FarIntensity, blurAmount + .05, lerpAmount) --shoving ur face in things REALLY blurs the background
			elseif d > 30 then
				DOF.NearIntensity = lerp(DOF.NearIntensity, blurAmount + .05, lerpAmount) --looking far away blurs close things a bit more
			else	-- reset blur values
				DOF.FarIntensity = lerp(DOF.FarIntensity, blurAmount, lerpAmount)
				DOF.NearIntensity = lerp(DOF.NearIntensity, blurAmount, lerpAmount)
			end
		end
	end)
end)