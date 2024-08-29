--!strict
local Player = game.Players.LocalPlayer
repeat
	wait()
until Player.Character

local name = Player.Name
local char = game.Workspace[Player.Name]

local Animation = script.Parent.CrouchAnimation

local animtrack = char.Humanoid:LoadAnimation(Animation)

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
	end
	if input.KeyCode == Enum.KeyCode.C then
		animtrack:Play()
		char.Humanoid.WalkSpeed = 0
	else
		animtrack:Stop()
		char.Humanoid.WalkSpeed = 14
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
	end

	if input.KeyCode == Enum.KeyCode.C then
		animtrack:Stop()
		char.Humanoid.WalkSpeed = 14
	end
end)