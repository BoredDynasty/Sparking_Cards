local RemoteEvent = game.ReplicatedStorage.RemoteEvents.SpecificUIHide.Letterbox
local top = script.Parent.top
local bottom = script.Parent.bottom


local TweenService = game:GetService("TweenService")
local TInfo = TweenInfo.new(
	3,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

local tween = game:WaitForChild("TweenService")

RemoteEvent.OnClientEvent:Connect(function(LookAtTime)
	top.Visible = true
	bottom.Visible = true
	tween:Create(top, TInfo, {BackgroundTransparency = 0}):Play()
	tween:Create(bottom, TInfo, {BackgroundTransparency = 0}):Play()
	if LookAtTime then
		task.wait(LookAtTime)

		tween:Create(top, TInfo, {BackgroundTransparency = 1}):Play()
		tween:Create(bottom, TInfo, {BackgroundTransparency = 1}):Play()
	else
		task.wait(5)
		tween:Create(top, TInfo, {BackgroundTransparency = 1}):Play()
		tween:Create(bottom, TInfo, {BackgroundTransparency = 1}):Play()
	end

end)