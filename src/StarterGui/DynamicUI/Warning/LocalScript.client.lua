local Remote = game:GetService("ReplicatedStorage").RemoteEvents.SpecificUIHide.NewWarning

local MainText = script.Parent.Main
local Body = script.Parent.Body
local Divider = script.Parent.Element

local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(
	0.2,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

local function visible()
	MainText.Visible = true
	Body.Visible = true
	Divider.Visible = true
end

local function noVisible()
	MainText.Visible = false
	Body.Visible = false
	Divider.Visible = false
end

local function phase1()
	TweenService:Create(MainText, TweenParams, {Position = UDim2.new(0.421, 0, 0.414, 0)}):Play()
	TweenService:Create(Body, TweenParams, {Position = UDim2.new(0.361, 0, 0.485, 0)}):Play()
	TweenService:Create(Divider, TweenParams, {Position = UDim2.new(0.498, 0, 0.475, 0)}):Play()
	TweenService:Create(MainText, TweenParams, {TextTransparency = 1}):Play()
	TweenService:Create(Body, TweenParams, {TextTransparency = 1}):Play()
	TweenService:Create(MainText.UIStroke, TweenParams, {Transparency = 1}):Play()
	TweenService:Create(Body.UIStroke, TweenParams, {Transparency = 1}):Play()
	TweenService:Create(Divider, TweenParams, {BackgroundTransparency = 0.5}):Play()
end

local function phase2()
	TweenService:Create(MainText, TweenParams, {Position = UDim2.new(0.421, 0, 0.454, 0)}):Play()
	TweenService:Create(Body, TweenParams, {Position = UDim2.new(0.361, 0, 0.525, 0)}):Play()
	TweenService:Create(Divider, TweenParams, {Position = UDim2.new(0.498, 0, 0.495, 0)}):Play()
	TweenService:Create(MainText, TweenParams, {TextTransparency = 0}):Play()
	TweenService:Create(Body, TweenParams, {TextTransparency = 0}):Play()
	TweenService:Create(MainText.UIStroke, TweenParams, {Transparency = 0.5}):Play()
	TweenService:Create(Body.UIStroke, TweenParams, {Transparency = 0.5}):Play()
	TweenService:Create(Divider, TweenParams, {BackgroundTransparency = 1}):Play()
end

Remote.OnClientEvent:Connect(function(message: string, DissapearTime: number)
	Body.Text = tostring(message)
	TweenService:Create(game:GetService("Lighting").Blur, TweenParams, {Size = 20})
	task.wait(0.5)
	visible()
	phase2()
	task.wait(tonumber(DissapearTime))
	phase1()
	task.wait(1)
	noVisible()
	TweenService:Create(game:GetService("Lighting").Blur, TweenParams, {Size = 0})
end)