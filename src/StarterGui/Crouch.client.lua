Player = game.Players.LocalPlayer
repeat
	wait()
until Player.Character

name = Player.Name
char = game.Workspace[Player.Name]

Animation = script.Anim

animtrack = char.Humanoid:LoadAnimation(Animation)

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
