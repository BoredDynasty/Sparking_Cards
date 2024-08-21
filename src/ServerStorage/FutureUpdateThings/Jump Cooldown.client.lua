--[=[

Scripted by: uhi_o

Thank you for using my asset for your personal work,

As you may have noticed, this is a LocalScript placed in Workspace by default.
We want to change up some things. First off start by placing this script
inside StarterPlayer > StarterCharacterScripts. After that is done, if you scroll a 
little down in this script, you will notice "local jumpCoolDown = 2". That would
be the variable contianing the jump cooldown which is the amount of seconds
taken before enabling the next jump for the character. The 2 can be changed
to any number or decimal number.
To finish off, change the "2.0" to your cooldown time in seconds.

Enjoy!


]=]--


-- // Only Edit Below \\--

-- Only change the number below! --
local jumpCooldown = .5 -- Change this to the cooldown for every jump (decimals accepted)
-- Number is in seconds --

--\\ Only Edit Above //--

local module = require(game.ReplicatedStorage.CircularProgressbar)


local UserInputService = game:GetService('UserInputService')

local plr = game.Players.LocalPlayer
local Jumped = false --Debounce

-- get player mouse
local mouse = plr:GetMouse()

local module = require(game.ReplicatedStorage.CircularProgressbar)

local frame = Instance.new('Frame', script.Parent)
frame.AnchorPoint = Vector2.new(.5, .5)
frame.Position = UDim2.new(.3, 0, .5, 0)
frame.BackgroundTransparency = 1

local circleObject = module:Create(frame, 30, 40, 100)

--[[circleObject:Set(1)   --> Will be set at 7
circleObject:Add(3)   --> Will be set at 10 because 7 + 3 == 10
circleObject:Add(-7)  --> Will be set at 3 because 10 + (-7) == 3
--]]


UserInputService.JumpRequest:Connect(function()
	local char = plr.Character -- some may place this script in StarterPlayer...
	if not Jumped then
		if char.Humanoid.FloorMaterial == Enum.Material.Air then return end -- Prevent mid air jumps
		Jumped = true --Making it true do it does not loop twice
		char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) --Making the character jump
		task.wait(jumpCooldown) -- yield x
		Jumped = false --Make it false so we can repeat it again
	else
		char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		
		--[[circleObject:SetEndFlag(7)
		task.wait(.5)

		--> The circle is now filled at 1/7, the First step
		circleObject:Flag(1)
		task.wait(.1)

		for i = 1, 3 do
			--> The circle is now filled at 2/7, then 3/7 and then 4/7
			circleObject:Flag()
			task.wait(.1)
		end

		for i = 1, 3 do
			--> This will only accomplish the 5th task, so circle is filled 5/7, 3 times
			circleObject:Flag(5)
			task.wait(.1)
		end

		--> The circle is now filled at 6/7
		circleObject:Flag()
		task.wait(.1)

		--> The circle is now filled at 7/7, the Last step, circle is full
		circleObject:Flag(7)
		--]]
	end
end)