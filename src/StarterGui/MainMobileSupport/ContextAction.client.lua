--!strict
local ContextActionService = game:GetService("ContextActionService")

local function collectTreasure(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		print("Collect treasure")
	end
end

ContextActionService:BindAction("Interact", collectTreasure, true, Enum.KeyCode.T, Enum.KeyCode.ButtonR1)
ContextActionService:SetPosition("Interact", UDim2.new(1, -70, 0, 10))
ContextActionService:SetTitle("Interact", "This has no use yet...")
-- Set image to blue "Collect" button
ContextActionService:SetImage("Interact", "rbxassetid://0123456789")
