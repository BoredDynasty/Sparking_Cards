local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")


local DrawCardsFrame = script.Parent.Parent.drawCardsFrame

local function handleAction(actionName, inputState, inputObject)
	if actionName == "OpenFrame" then
		if inputState == Enum.UserInputState.Begin then
			DrawCardsFrame.Visible = true
		else
			DrawCardsFrame.Visible = false
		end
	end
end

-- Detect if Gamepad is Enabled
if UserInputService.GamepadEnabled then
	local icons = script.Parent.Icons:GetDescendants()
	for _, icon in pairs(icons) do
		if icon:IsA("ImageButton") then
			icon.Visible = true
		end
	end
end

UserInputService.GamepadConnected:Connect(function(gamepad)
	print("User has connected controller: " .. tostring(gamepad))
	local icons = script.Parent.Icons:GetDescendants()
	for _, icon in pairs(icons) do
		if icon:IsA("ImageButton") then
			icon.Visible = true
		end
	end
end)

UserInputService.GamepadDisconnected:Connect(function(gamepad)
	print("User has disconnected controller: " .. tostring(gamepad))
	local icons = script.Parent.Icons:GetDescendants()
	for _, icon in pairs(icons) do
		if icon:IsA("ImageButton") then
			icon.Visible = false
		end
	end
end)

-- Controller Support
ContextActionService:BindAction(
	"OpenFrame", 
	handleAction, 
	false, 
	Enum.KeyCode.ButtonY
) -- ,Enum.KeyCode.H,

ContextActionService:UnbindAction("OpenFrame")

