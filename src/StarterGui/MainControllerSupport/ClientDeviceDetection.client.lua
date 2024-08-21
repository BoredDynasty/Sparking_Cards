local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local lastInput = UserInputService:GetLastInputType()
local device = nil

local player = game.Players.LocalPlayer
local character = player.Character
local head = character:WaitForChild("Head")

local Overhead = script.OverheadGui
local OverHeadClone = Overhead:Clone()
OverHeadClone.Parent = head

local ImageInstance = Instance.new("ImageLabel")
ImageInstance.Name = "DeviceImage"
ImageInstance.Size = UDim2.new(0, 25, 0, 25)
ImageInstance.Image = "rbxassetid://6764432293"
ImageInstance.Parent = Overhead.Background

-- Is Verified?
if player:IsVerified() then
	OverHeadClone.Background.Username.Text = player.DisplayName or player.Name
	OverHeadClone.Background.Image.Visible = true
else
	OverHeadClone.Background.Image.Visible = false
	OverHeadClone.Background.Username.Text = player.DisplayName or player.Name
end

-- When [Device]
local function desktop()
	ImageInstance.ImageRectOffset = Vector2.new(100, 900)
	ImageInstance.ImageRectSize = Vector2.new(50, 50)
end

local function mobile()
	ImageInstance.ImageRectOffset = Vector2.new(100, 500)
	ImageInstance.ImageRectSize = Vector2.new(50, 50)
end

local function console()
	ImageInstance.ImageRectOffset = Vector2.new(200, 100)
	ImageInstance.ImageRectSize = Vector2.new(100, 100)
end


-- Returning Supported Controls

local availableInputs = UserInputService:GetSupportedGamepadKeyCodes(Enum.UserInputType.Gamepad1)

for _, control in availableInputs do
	print(control)
	return control
end
-- Detecting Trigger Pressure

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonL1 then
			print("Pressure on left trigger has changed:", input.Position.Z)
		elseif input.KeyCode == Enum.KeyCode.ButtonR1 then
			print("Pressure on right trigger has changed:", input.Position.Z)
		end
	end
end)

-- Detecting Device

while device == nil do
	lastInput = UserInputService:GetLastInputType()
	if lastInput==Enum.UserInputType.MouseMovement then
		device = "Desktop"
		print(device)
		desktop()
	elseif lastInput==Enum.UserInputType.Touch then
		device = "Mobile"
		print(device)
		mobile()
	elseif lastInput==Enum.UserInputType.Gamepad1 then
		device = "Console"
		print(device)
		console()
	end
	wait()
end

