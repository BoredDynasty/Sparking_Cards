local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local frame1 = script.Parent.CardFrame1
local frame2 = script.Parent.CardFrame2

local isDragging = false
local dragObject = nil

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
        if frame1.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame1.AbsolutePosition.X + frame1.AbsoluteSize.X and
           frame1.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame1.AbsolutePosition.Y + frame1.AbsoluteSize.Y then
            isDragging = true
            dragObject = frame1
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
            if frame2.AbsolutePosition.X <= mouseLocation.X and mouseLocation.X <= frame2.AbsolutePosition.X + frame2.AbsoluteSize.X and
               frame2.AbsolutePosition.Y <= mouseLocation.Y and mouseLocation.Y <= frame2.AbsolutePosition.Y + frame2.AbsoluteSize.Y then
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
