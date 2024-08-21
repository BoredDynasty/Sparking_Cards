local LetterboxRemote = game.ReplicatedStorage.RemoteEvents.SpecificUIHide.Letterbox
local LetterboxUI = game.StarterGui.UIEffects.Letterbox

local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tween = game:GetService('TweenService');

LetterboxRemote.OnServerEvent:Connect(function()
	print("Letterbox OnServentEvent fired. - " .. script.Parent.Name)
	-- Get all the descendants in LetterboxUI

	for _, descendant in pairs(LetterboxUI) do
		if descendant:IsA("Frame") then
			print("Gotten Descendants From Letterbox. - " .. script.Parent.Name)
			descendant.Visible = true
			task.wait(0.1)
			tween:Create(descendant, TInfo, { Transparency = 0 }):Play()
		end
	end
end)
