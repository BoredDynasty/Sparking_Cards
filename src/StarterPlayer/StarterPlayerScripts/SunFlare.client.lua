--!nonstrict
--local FLARE_IMAGE = "rbxassetid://275683838" --hexagon
local FLARE_IMAGE = "rbxassetid://275403424" --pentagon
local SUN_IMAGE = "rbxassetid://277033149"
local FLARE_COLOR = Color3.new(1, 1, 0.8)
local FLARE_ROTATION = -25
local MIN_BRIGHT_TRANS = 0.5
local SUN_SIZE = Vector2.new(0.2, 0.2) --TODO: make these constants work with different FOV
local SUN_OFFSET = Vector2.new(0.004, 0.004) --TODO: make these constants work with different FOV
local TWEEN_SPEED = 0.5
local FLARE_DIST = { --1 is the distance from the center to the sun
	1.7,
	0.3,
	-0.3,
	-0.9,
}
local FLARE_SIZES = { --1 is the size of the sun
	0.7,
	0.2,
	1.2,
	0.45,
}
local FLARE_TRANS = { --0-1
	0.8,
	0.7,
	0.9,
	0.6,
}
local SUN_FLARE_SIZE = 15 --how much bigger the sun image is compared to the sun itself
local SUN_FLARE_TRANS = 0
local SUN_FLARE_COLOR = Color3.new(1, 1, 0.95)

local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local realMod = 1 --for tweening

local function Clip(n, l, h)
	if n < l then
		return l
	end
	if n > h then
		return h
	end
	return n
end

local function GetSunPosition()
	local screenPoint = camera:WorldToScreenPoint(camera.CFrame.Position + lighting:GetSunDirection())
	return Vector2.new(screenPoint.X, screenPoint.Y), screenPoint.Z > 0
end

local function ScreenCenter()
	return camera.ViewportSize / 2
end

local function IsObstructed(ignore)
	return workspace:Raycast(Ray.new(camera.CFrame.Position, lighting:GetSunDirection() * 900), ignore) ~= nil
end

local function brightness(x)
	return Clip(1 - (1 - MIN_BRIGHT_TRANS) * x, 0, 1)
end

local function OnCharacterAdded(character)
	local root = character:WaitForChild("HumanoidRootPart")

	local flares = {}
	local screenGui
	do --get valid ScreenGui
		for _, child in pairs(script.Parent:GetChildren()) do
			if child:IsA("ScreenGui") then
				screenGui = child
				break
			end
		end
		if not screenGui then
			screenGui = Instance.new("ScreenGui")
			screenGui.Parent = player.PlayerGui
		end
	end
	screenGui.IgnoreGuiInset = true
	--create washout effect
	local brightScreen = Instance.new("Frame")
	brightScreen.Parent = screenGui
	brightScreen.Name = "FlareWashout"
	brightScreen.Size = UDim2.new(1, 0, 1, 0)
	brightScreen.BackgroundColor3 = FLARE_COLOR
	brightScreen.ZIndex = 10
	brightScreen.Transparency = 1

	--create flares
	for i = 1, #FLARE_DIST do
		local flare = Instance.new("ImageLabel")
		flare.Parent = screenGui
		flare.Name = "FlareGhost"
		flare.SizeConstraint = Enum.SizeConstraint.RelativeYY
		flare.Size = UDim2.new(FLARE_SIZES[i] * SUN_SIZE.X, 0, FLARE_SIZES[i] * SUN_SIZE.Y, 0)
		flare.Rotation = FLARE_ROTATION
		flare.Image = FLARE_IMAGE
		flare.ImageColor3 = FLARE_COLOR
		flare.BackgroundTransparency = 1
		flare.ImageTransparency = FLARE_TRANS[i]
		flare.ZIndex = 10
		flares[#flares + 1] = flare
	end
	--create sun flare
	local sunFlare = Instance.new("ImageLabel")
	sunFlare.Parent = screenGui
	sunFlare.Name = "SunFlare"
	sunFlare.SizeConstraint = Enum.SizeConstraint.RelativeYY
	sunFlare.Size = UDim2.new(SUN_FLARE_SIZE * SUN_SIZE.X, 0, SUN_FLARE_SIZE * SUN_SIZE.Y, 0)
	sunFlare.Image = SUN_IMAGE
	sunFlare.ImageColor3 = SUN_FLARE_COLOR
	sunFlare.BackgroundTransparency = 1
	sunFlare.ImageTransparency = SUN_FLARE_TRANS
	sunFlare.ZIndex = 10

	runService:UnbindFromRenderStep("SunFlareReposition")
	runService:BindToRenderStep("SunFlareReposition", Enum.RenderPriority.Last.Value, function()
		--reposition flares
		local sunPosition, isInFront = GetSunPosition()
		local isClear = not IsObstructed(
			(root.Position + Vector3.new(0, 1.5, 0) - camera.CFrame.Position).Magnitude < 1.1 and character or nil
		) --ignores character when zoomed in
		local targetMod = isClear and 1 or 0

		realMod = realMod * (1 - TWEEN_SPEED) + targetMod * TWEEN_SPEED

		local screenCenter = ScreenCenter()
		local vec = sunPosition - screenCenter

		for i = 1, #flares do
			flares[i].ImageTransparency = 1 - realMod + FLARE_TRANS[i] * realMod
			local thisSize = flares[i].AbsoluteSize
			local thisPosition = screenCenter + vec * FLARE_DIST[i]
			flares[i].Position =
				UDim2.new(SUN_OFFSET.x, thisPosition.x - thisSize.x / 2, SUN_OFFSET.y, thisPosition.y - thisSize.y / 2)
			flares[i].Visible = isInFront
		end

		sunFlare.ImageTransparency = 1 - realMod + SUN_FLARE_TRANS * realMod
		local sunFlareSize = sunFlare.AbsoluteSize
		sunFlare.Position = UDim2.new(
			SUN_OFFSET.x,
			sunPosition.x - sunFlareSize.x / 2,
			SUN_OFFSET.y,
			sunPosition.y - sunFlareSize.y / 2
		)
		sunFlare.Visible = isInFront

		--blur effect
		local cosAngle = camera.CFrame.LookVector:Dot(lighting:GetSunDirection())
		brightScreen.Transparency = 1 - realMod + brightness(cosAngle) * realMod
	end)
end

repeat
	task.wait()
until player.Character --fix for laggy CharacterAdded stuff
OnCharacterAdded(player.Character)
player.CharacterAdded:Connect(OnCharacterAdded)
