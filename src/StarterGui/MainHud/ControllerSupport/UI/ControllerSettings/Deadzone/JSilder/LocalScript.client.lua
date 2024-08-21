local Mouse = game.Players.LocalPlayer:GetMouse()
local MouseisOn = false
local Slider = script.Parent
local Back = script.Parent.Back
local Point = script.Parent.Point
local MouseisDown = false
local MouseButton = script.Parent.MouseButton
local Value = script.Parent.Value
local Max = script.Parent.Max
local IntOnly = script.Parent.IntOnly
local ValueLabelMultiply = script.Parent.ValueLabelMultiply
local ValueLabel = script.Parent.ValueLabel
local Grid = script.Parent.Grid
local GridFrame = script.Parent.GridFrame
local GridColor3 = script.Parent.GridColor3
function UpDateGrid()
	if Grid.Value == true then
		GridFrame.Visible = true
		GridFrame:ClearAllChildren()
		for i = 1,Max.Value do
			local NewGridPart = Instance.new("ImageLabel")
			NewGridPart.Image = "rbxassetid://1217158727"
			NewGridPart.AnchorPoint = Vector2.new(0.5,0.5)
			NewGridPart.Position = UDim2.new(i/Max.Value,0,0.5,0)
			NewGridPart.BackgroundTransparency = 1
			NewGridPart.ImageColor3 = GridColor3.Value
			NewGridPart.Size = UDim2.new(0,2,0,2)
			NewGridPart.ImageTransparency = 0.2
			NewGridPart.ZIndex = 3
			NewGridPart.Parent = GridFrame
		end
	else
		GridFrame.Visible = false
	end
end
Grid:GetPropertyChangedSignal("Value"):Connect(UpDateGrid)
GridColor3:GetPropertyChangedSignal("Value"):Connect(UpDateGrid)
Max:GetPropertyChangedSignal("Value"):Connect(UpDateGrid)
UpDateGrid()
MouseButton.MouseEnter:Connect(function()
	MouseisOn = true
	Point.MouseOn:TweenSize(UDim2.new(3,0,3,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
end)
MouseButton.MouseLeave:Connect(function()
	MouseisOn = false
	if MouseisDown == false then
		Point.MouseOn:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
	end
end)
function DoChangeValue()
	local NewValue = Value.Value
	Point:TweenPosition(UDim2.new(NewValue/Max.Value,0,0.5,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
	Back:TweenSize(UDim2.new(NewValue/Max.Value,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
	Point.ValueLabel.Text.Text = NewValue * ValueLabelMultiply.Value
	workspace[game.Players.LocalPlayer.Name].Humanoid.JumpPower = NewValue
end
Value:GetPropertyChangedSignal("Value"):Connect(DoChangeValue)
Max:GetPropertyChangedSignal("Value"):Connect(DoChangeValue)
function SetValueFromMousePos()
	local Pos = Mouse.X - Slider.AbsolutePosition.X
	if Pos < 0 or Pos == 0 then
		Pos = 0
	end
	if Pos > Slider.AbsoluteSize.X or Pos == Slider.AbsoluteSize.X then
		Pos = Slider.AbsoluteSize.X
	end
	if IntOnly.Value then
		Value.Value = math.floor((Pos/Slider.AbsoluteSize.X)*Max.Value+0.5)
	else
		Value.Value = (Pos/Slider.AbsoluteSize.X)*Max.Value
	end
end
MouseButton.MouseButton1Down:Connect(function()
	if MouseisOn == true then
		MouseisDown = true
		SetValueFromMousePos()
		Point:TweenSize(UDim2.new(0,14,0,14),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true,nil)
		Point.MouseDown:TweenSize(UDim2.new(3,0,3,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
		if ValueLabel.Value == true then
			Point.ValueLabel:TweenSize(UDim2.new(0, 28,0, 40),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
		end
	end
end)
function Button1Up()
	MouseisDown = false
	Point:TweenSize(UDim2.new(0,12,0,12),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true,nil)
	Point.MouseDown:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
	if ValueLabel.Value == true then
		Point.ValueLabel:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
	end
	if MouseisOn == false then
		Point.MouseOn:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
	end
end
MouseButton.MouseButton1Up:Connect(Button1Up)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputEnded:Connect(function(Key, GameProcessedEvent)
	if Key.UserInputType == Enum.UserInputType.MouseButton1 then
		Button1Up()
	end
end)
Mouse.Move:Connect(function()
	if MouseisDown == true then
		SetValueFromMousePos()
	end
end)