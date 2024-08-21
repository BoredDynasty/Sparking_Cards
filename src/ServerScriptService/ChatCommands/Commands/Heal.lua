local module = {
	
	["cmd"] = "heal",
	["permission"] = "commandheal"
	
}

function module.onCommand(sender, args)
	
	if #args == 0 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /heal <player>", Color3.new(1, 0.5, 0.5))
		
	else
		
		local target = nil
		
		for _,v in pairs(game.Players:GetChildren()) do
			
			if string.lower(v.Name) == string.lower(args[1]) then
				target = v
				break
			end
			
		end
		
		if target == nil then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player not found.", Color3.new(1, 0.5, 0.5))
			
		else
			
			target.Character.Humanoid.Health = target.Character.Humanoid.MaxHealth
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player healed.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module