--!strict

local Players = game:GetService("Players")

local Users = "Dynablox1005" -- The user that can use loadstring()

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if player.Name == Users then
			local pattern = message:match("loadstring()", 0)
			if pattern then
				loadstring(tostring(message))()
				print(tostring(message) .. " Command run.")
			end
		else
			print("You aren't allowed to use loadstring!")
		end
	end)
end)
