--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerFaces = {
	Angry = ReplicatedStorage.Faces:FindFirstChild("Angry-01"),
	Confused = ReplicatedStorage.Faces:FindFirstChild("Confused-01"),
	Surprised2 = ReplicatedStorage.Faces:FindFirstChild("Surprised-02"),
	Surprised = ReplicatedStorage.Faces:FindFirstChild("Surprised-01"),
}

local function onPlayerChatted(player, message)
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:FindFirstChild("Head")
	if not head then
		return
	end

	for faceName, faceAttachment in PlayerFaces do
		if string.find(message, faceName) then
			local clonedFace = faceAttachment:Clone()
			clonedFace.Parent = head

			task.wait(5)

			if clonedFace and clonedFace.Parent == head then
				clonedFace:Destroy()
			end
		end
	end
end

local function onPlayerAdded(player)
	player.Chatted:Connect(function(message)
		onPlayerChatted(player, message)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
