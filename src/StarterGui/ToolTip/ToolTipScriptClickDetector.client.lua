-- Made by Txab (@TxabYT) --
----------------------------

local Tooltip = script.Parent.TooltipClick

local Mouse = game.Players.LocalPlayer:GetMouse()
local Offset = UDim2.new(0.01, 0, -0.01, 0) -- Change this if you made a custom Tooltip UI

Mouse.Move:Connect(function()
	if Mouse.Target then
		if Mouse.Target:FindFirstChild("Tooltip") and Mouse.Target:FindFirstChild("Tooltip").Value == true and Mouse.Target:FindFirstChild("ClickDetector") then
			Tooltip.NameUI.Text = Mouse.Target.Tooltip:FindFirstChild("Name").Value
			Tooltip.DescUI.Text = Mouse.Target.Tooltip:FindFirstChild("Desc").Value
			Tooltip.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y) + Offset
			script.Parent.Tooltip.Visible = true
			--Mouse.Icon = "rbxassetid://9563790939"
		else
			script.Parent.Tooltip.Visible = false
			--Mouse.Icon = "rbxassetid://9563784745"
		end
	else
		script.Parent.Tooltip.Visible = false
		--Mouse.Icon = "rbxassetid://9563784745"
	end
end)