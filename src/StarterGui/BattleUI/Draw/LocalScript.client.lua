local button = script.Parent
local buttonTransp = button.BackgroundTransparency

local stroke = button.UIStroke
local strokeTransp = stroke.Transparency

local frame = script.Parent.Parent.drawCardsFrame

local tip = script.Parent.Control

local Notis = script.Parent.Notis

local Remote = game.ReplicatedStorage.RemoteEvents.CreateNotification
local HideRemote = game.ReplicatedStorage.RemoteEvents.SpecificUIHide.DrawCardsHidden

local tween = game:GetService("TweenService")
local tInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- when button hasnt been press in 20s, make the buttonTransp 1.


-- Make the buttonTransp 0 when the players mouse hovers over button.
button.MouseEnter:Connect(function()
	tween:Create(button, tInfo, {BackgroundTransparency = 0}):Play()
	tween:Create(stroke, tInfo, {Transparency = 0}):Play()
	tween:Create(tip, tInfo, {TextTransparency = 0.5}):Play()
end)

button.MouseLeave:Connect(function()
	tween:Create(button, tInfo, {BackgroundTransparency = 1}):Play()
	tween:Create(stroke, tInfo, {Transparency = 1}):Play()
	tween:Create(tip, tInfo, {TextTransparency = 1}):Play()
end)

button.MouseButton1Down:Connect(function()
	-- The frame should open. when the player presses again, it should close.
	if frame.Visible == false then
		frame.Visible = true
	else
		frame.Visible = false
	end
end)

local bp = UDim2.new(0.807, 0, 0.919, 0)
local ap = UDim2.new(0.999, 0, 0.919, 0)

Remote.OnClientEvent:Connect(function() 	
	-- Notis.Text goes up by 1.
	Notis.Text = tonumber(Notis.Text) + 1

end)