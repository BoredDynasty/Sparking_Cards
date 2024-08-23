--!strict

--[[
java - 2022

hi im not very good at commentary or doccumentation, so ill just show an example script.



--MODULE /[EXAMPLE]/--

local BlurModule = require(script.UIBlur)

local TestBlur
do
	TestBlur = BlurModule.new(script.Parent.Frame)

	task.delay(7, function()
		TestBlur:Disconnect()
	end)
end

--//CHANGELOG//--


 ./22/10/14/ - 10:40
 -- fixed resolution bug. script now works universally. sorry for the wait!
 massive thanks to low for recalculating everything. i was not the one who fixed this.
 
 ./22/10/15/ - 7:07
 -- number value tweaks.
 
 
 
 -- changelog end.
]]

local camera = workspace.CurrentCamera

local directory

local offset = 0.31
local scale = 0.000182908 * (2160 / camera.ViewportSize.Y)

local parts = {}
local count = 0

local blurscaleoffset = Vector2.new(-22 * scale, -22 * scale)

local function propvar(instance, properties) --//did this to make the code a lot more clean//
	for a, b in next, properties do
		instance[a] = b
	end

	return instance
end

directory = propvar(Instance.new("Folder"), {
	Name = "GuiBlur",

	Parent = camera,
})

local blur = propvar(Instance.new("DepthOfFieldEffect"), {
	FarIntensity = 0,
	FocusDistance = 1,
	InFocusRadius = 0,
	NearIntensity = 1,

	Parent = camera,
})

local REFERENCE_part = propvar(Instance.new("Part"), {
	Anchored = true,
	CanCollide = false,
	CanTouch = false,
	CastShadow = false,
	Massless = true,
	Color = Color3.new(1, 1, 1),
	Material = Enum.Material.Glass,
	Transparency = 0.999,
})

propvar(Instance.new("BlockMesh"), {
	Offset = Vector3.new(0, 0, 0.025),
	Scale = Vector3.new(1, 1, 0),

	Parent = REFERENCE_part,
})

local module = {
	new = function(GuiObject)
		local BlurObject = {}

		local part = REFERENCE_part:Clone()

		local NewSize = Vector2.new(GuiObject.AbsoluteSize.X * scale, GuiObject.AbsoluteSize.Y * scale)
		local NewPosition = Vector2.new(GuiObject.AbsolutePosition.X * scale, GuiObject.AbsolutePosition.Y * scale)

		local Screen = Vector2.new((camera.ViewportSize.X * scale) / 2, -(camera.ViewportSize.Y * scale) / 2)

		local Corner = Vector3.new(NewSize.X / 2, -(NewSize.Y / 2), 0) + Vector3.new(-Screen.X, -Screen.Y, 0)

		part.Size = Vector3.new(NewSize.X, NewSize.Y, 0)
		part.CFrame = camera.CFrame * CFrame.new(Vector3.new(0, 0, -offset))
		part.Parent = directory

		count += 1

		parts[count] = {
			[1] = part,
			[2] = Corner + Vector3.new(NewPosition.X, -NewPosition.Y - (36 * scale), 0),
			[3] = GuiObject,
		}

		function BlurObject:Disconnect()
			local a = parts[count]

			a[1]:Destroy()
			a = nil
		end

		return BlurObject
	end,
}

game:GetService("RunService").RenderStepped:Connect(function()
	scale = 0.000182908 * (2160 / camera.ViewportSize.Y)
	blurscaleoffset = Vector2.new(-22 * scale, -22 * scale)

	for _, a in next, parts do
		local NewSize = Vector2.new(a[3].AbsoluteSize.X * scale, a[3].AbsoluteSize.Y * scale)
		local NewPosition = Vector2.new(a[3].AbsolutePosition.X * scale, a[3].AbsolutePosition.Y * scale)

		local Screen = Vector2.new((camera.ViewportSize.X * scale) / 2, -(camera.ViewportSize.Y * scale) / 2)

		local Corner = Vector3.new(NewSize.X / 2, -(NewSize.Y / 2), 0) + Vector3.new(-Screen.X, -Screen.Y, 0)

		a[2] = Corner + Vector3.new(NewPosition.X, -NewPosition.Y - (36 * scale), 0)
		a[1].CFrame = camera.CFrame * CFrame.new(Vector3.new(0, 0, -offset)) * CFrame.new(a[2])
		a[1].Size = Vector3.new(NewSize.X, NewSize.Y, 0) + Vector3.new(blurscaleoffset.X, blurscaleoffset.Y, 0)
	end
end)

return module
