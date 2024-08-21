wait()

--the server can't access playerscripts, but it can access playergui and then the script can sneak in to playerscripts
script.Parent = game.Players.LocalPlayer:WaitForChild("PlayerScripts")

local remote = game.ReplicatedStorage:WaitForChild("ChatCommands")

remote.Message.OnClientEvent:Connect(function(message, color)
	
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = message,
		Color = color
	})
	
end)