
local p = game.Players.LocalPlayer
local gb = script.Parent:WaitForChild("GraphicsBlock")
local sound = script.Parent:WaitForChild("Sound")

local US = UserSettings()
local UGS = US:GetService("UserGameSettings")

local function getGraphicsSetting()
	return UGS.SavedQualityLevel.Value
end

script.Parent.GraphicsBlock.Visible = true
sound:Play()
local current = getGraphicsSetting()

game:GetService("RunService").RenderStepped:connect(function()
	local s = getGraphicsSetting()
	if s < 5 and s ~= current then print(s)
		if not gb.Visible then 
			gb.Visible = true sound:Play() 
		end
		current = s
		sound.Pitch = .5 + (s/9)*.5
	elseif s >= 5 then
		if gb.Visible then 
			gb.Visible = false sound:Stop() 
		end
	end
end)
