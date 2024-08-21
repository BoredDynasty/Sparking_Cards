-- Made by Txab (@TxabYT) --
----------------------------

local Tooltip = script.Parent.Tooltip

local Mouse = game.Players.LocalPlayer:GetMouse()
local Offset = UDim2.new(0.015, 0, -0.01, 0)

Mouse.Move:Connect(function()
	if Mouse.Target then
		if Mouse.Target:FindFirstChild("Tooltip") and Mouse.Target:FindFirstChild("Tooltip").Value == true then
			Tooltip.NameUI.Text = Mouse.Target.Tooltip:FindFirstChild("Name").Value
			Tooltip.DescUI.Text = Mouse.Target.Tooltip:FindFirstChild("Desc").Value
			Tooltip.DescUI.RichText = false
			Tooltip.NameUI.RichText = false
			--Mouse.Icon = "rbxassetid://9563790132"
			
			local RichBool = Mouse.Target.Tooltip:FindFirstChildOfClass("BoolValue")
			if RichBool then
				Tooltip.DescUI.RichText = true
				Tooltip.NameUI.RichText = true
			end
			Tooltip.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y) + Offset
			script.Parent.Tooltip.Visible = true
		else
			script.Parent.Tooltip.Visible = false
			Tooltip.DescUI.RichText = false
			Tooltip.NameUI.RichText = false
			--Mouse.Icon = "rbxassetid://9563784745"
		end
	else
		Tooltip.DescUI.RichText = false
		Tooltip.NameUI.RichText = false
		script.Parent.Tooltip.Visible = false
		--Mouse.Icon = "rbxassetid://9563784745"

	end
end)