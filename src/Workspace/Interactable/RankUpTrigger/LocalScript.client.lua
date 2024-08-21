local LetterboxRemote = game.ReplicatedStorage.RemoteEvents.SpecificUIHide.Letterbox
local LetterboxUI = game.StarterGui.UIEffects.Letterbox


local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tween = game:GetService("TweenService")


LetterboxRemote.OnClientEvent:Connect(function()
	print("Letterbox OnServentEvent fired. - " .. script.Parent.Name)
	-- Get all the descendants in LetterboxUI

	for _, descendant in pairs(LetterboxUI) do
		if descendant:IsA("Frame") or descendant.Visible == false then
			descendant.Visible = true
			--task.wait(0.1)
			--tween:Create(descendant, TInfo, {BackgroundTransparency = 0}):Play()
		end
	end
end)
