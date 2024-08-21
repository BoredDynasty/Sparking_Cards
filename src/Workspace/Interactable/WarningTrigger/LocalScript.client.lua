local LetterboxRemote = game.ReplicatedStorage.Dialogue
local Click = script.Parent.ClickDetector

local message = script.Parent:GetAttribute("DialogueText")
local DissapearTime = script.Parent:GetAttribute("DissapearTime")
local Camera = script.Parent:GetAttribute("CameraBool")

local db = false

Click.MouseClick:Connect(function(playerWhoClicked: Player)
	local character = playerWhoClicked.Character
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 0
	end
	
	LetterboxRemote:FireServer(message, DissapearTime, Camera)
	print("Dialogue Request Processed")
	
	task.wait(DissapearTime)
	humanoid.WalkSpeed = 14
end)
