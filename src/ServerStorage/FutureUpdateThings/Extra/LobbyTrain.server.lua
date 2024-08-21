local train = script["Subway Train"]
local trainSound = train.shell.Sound

-- Make a table for variables
local FirstBogey = {
	trainStartPosition = CFrame.new(236.568, -375.007, 1379.471);
	trainMiddlePosition = CFrame.new(390.568, -375.007, 1379.471);
	trainEndPosition = CFrame.new(499.568, -375.007, 1379.471);
}

local Tinfo = TweenInfo.new(
	6,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.In
)


local TweenService = game:GetService("TweenService")

local Tween1 = TweenService:Create(train, Tinfo, {CFrame = FirstBogey.trainMiddlePosition})
local Tween2 = TweenService:Create(train, Tinfo, {CFrame = FirstBogey.trainEndPosition})
local Tween3 = TweenService:Create(train, Tinfo, {CFrame = FirstBogey.trainStartPosition})

repeat
	wait(50)
	Tween1:Play()
	task.wait(5)
	Tween2:Play()
until train.Position == FirstBogey.trainMiddlePosition

if train.Position == FirstBogey.trainMiddlePosition then
	Tween3:Play()
end