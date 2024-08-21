function generate()
	
	local replicated = Instance.new("Folder")
	replicated.Name = "ChatCommands"
	
	local message = Instance.new("RemoteEvent")
	message.Name = "Message"
	message.Parent = replicated
	
	replicated.Parent = game.ReplicatedStorage
	
end

return generate