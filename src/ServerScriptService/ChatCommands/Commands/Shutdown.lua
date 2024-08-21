local module = {
	
	["cmd"] = "shutdown",
	["permission"] = "commandshutdown"
	
}

function module.onCommand(sender, args)
	
	for _,v in pairs(game.Players:GetChildren()) do
		
		v:Kick("Server shutting down.")
		
	end
	
	game.Players.PlayerAdded:Connect(function(player)
		
		player:Kick("Server shutting down.")
		
	end)
	
end

return module