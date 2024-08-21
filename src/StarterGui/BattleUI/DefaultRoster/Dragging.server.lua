local FramesAltogether = script.Parent:GetDescendants()


local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Define the Frames Seperately

local frame1 = script.Parent.CardFrame1
local frame2 = script.Parent.CardFrame2
local frame3 = script.Parent.CardFrame3

frame1.Draggable = true
frame2.Draggable = true
frame3.Draggable = true


-- Is Dragging for the independant script

local isDragging = false
local dragObject = nil

local isDraggingBool = script.Parent.isDragging

local UIS = game:GetService("UserInputService")

-- local Mouse = game.Players.LocalPlayer:GetMouse()	
local MouseLocation = UIS:GetMouseLocation()

local CardModel = game.ReplicatedStorage["Meshes/Card_model0"]

local DropArea = script.Parent.Parent.Reference.DropCard
--[[

for _, FramesAltogether in pairs(FramesAltogether) do
	if FramesAltogether:IsA("Frame") then
		FramesAltogether.Draggable = true -- This is important
		FramesAltogether.Active = true
	end
end

for _, FramesAltogether in pairs(FramesAltogether) do
	if FramesAltogether:IsA("Frame") then
		FramesAltogether.DragBegin:Connect(function()
			isDraggingBool.Value = true
		end)
		FramesAltogether.DragStopped:Connect(function()
			isDraggingBool.Value = false
		end)
	end
end

if isDraggingBool == true and MouseLocation.X >= DropArea.AbsolutePosition.X and MouseLocation.X <= DropArea.AbsolutePosition.X + DropArea.AbsoluteSize.X and MouseLocation.Y >= DropArea.AbsolutePosition.Y and MouseLocation.Y <= DropArea.AbsolutePosition.Y + DropArea.AbsoluteSize.Y then
	print("Mouse is in DropArea!")
	local newpart = Instance.new("Part", workspace)
	newpart.Name = "NewPart"
	newpart.CFrame = CFrame.new(545, -499, 981)
	newpart.Size = Vector3.new(7, 7, 7)
	newpart.Anchored = true
end

--]]

-- If the Mouse position is within DropArea.

--[[local function isMouseInDropArea()
	local mouseLocation = UserInputService:GetMouseLocation()
	return mouseLocation.X >= DropArea.AbsolutePosition.X and mouseLocation.X <= DropArea.AbsolutePosition.X + DropArea.AbsoluteSize.X
		and mouseLocation.Y >= DropArea.AbsolutePosition.Y and mouseLocation.Y <= DropArea.AbsolutePosition.Y + DropArea.AbsoluteSize.Y
end

-- When the frames are dragged into DropArea.
--[[
local function createNewPart()
	local newPart = Instance.new("Part")
	newPart.Size = Vector3.new(4, 1, 2)
	newPart.Position = Vector3.new(0, 10, 0)
	newPart.Anchored = true
	newPart.Parent = Workspace
end

local function onInputBegan(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouseLocation = UserInputService:GetMouseLocation()
		-- Frame 1
		if frame1.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame1.AbsolutePosition.X + frame1.AbsoluteSize.X and
			frame1.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame1.AbsolutePosition.Y + frame1.AbsoluteSize.Y then
			isDragging = true
			dragObject = frame1
		end
		-- Frame 2
		if frame2.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame1.AbsolutePosition.X + frame1.AbsoluteSize.X and
			frame2.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame1.AbsolutePosition.Y + frame1.AbsoluteSize.Y then
			isDragging = true
			dragObject = frame2
			-- Frame 3
		if frame3.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame1.AbsolutePosition.X + frame1.AbsoluteSize.X and
				frame3.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame1.AbsolutePosition.Y + frame1.AbsoluteSize.Y then
				isDragging = true
				dragObject = frame3
			end
		end
		
	end
end

local function onInputChanged(input)
	if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouseLocation = UserInputService:GetMouseLocation()
		dragObject.Position = UDim2.new(0, mouseLocation.X - dragObject.AbsoluteSize.X / 2, 0, mouseLocation.Y - dragObject.AbsoluteSize.Y / 2)
	end
end

local function onInputEnded(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if isDragging then
			local mouseLocation = UserInputService:GetMouseLocation()
			-- Frame 1
			if frame1.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame1.AbsolutePosition.X + frame1.AbsoluteSize.X and
				frame1.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame1.AbsolutePosition.Y + frame1.AbsoluteSize.Y then
				createNewPart()
			end
			-- Frame 2
			if frame2.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame2.AbsolutePosition.X + frame2.AbsoluteSize.X and
				frame2.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame2.AbsolutePosition.Y + frame2.AbsoluteSize.Y then
				createNewPart()
			end
			-- Frame 3
			if frame3.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame3.AbsolutePosition.X + frame3.AbsoluteSize.X and
				frame3.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame3.AbsolutePosition.Y + frame3.AbsoluteSize.Y then
				createNewPart()
			end
			
			isDragging = false
			dragObject = nil
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputEnded)
--]]