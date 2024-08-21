local module = {
	
	["cmd"] = "walkspeed",
	["permission"] = "commandwalkspeed"
	
}

function module.onCommand(sender, args)
	
	if #args == 0 or #args == 1 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /walkspeed <player> <size>", Color3.new(1, 0.5, 0.5))
		
	else
		
		local value = tonumber(args[2])
		
		if value == nil then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "The size must be a number.", Color3.new(1, 0.5, 0.5))
			
			return
			
		end
		
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
			
			target.Character.Humanoid.WalkSpeed = value
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Walk speed changed.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module