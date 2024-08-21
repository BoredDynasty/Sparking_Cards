local module = {
	
	["cmd"] = "god",
	["permission"] = "commandgod"
	
}

function module.onCommand(sender, args)
	
	if #args == 0 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /god <player>", Color3.new(1, 0.5, 0.5))
		
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
			
			if target.Character.Humanoid.MaxHealth == math.huge then
				
				target.Character.Humanoid.MaxHealth = 100
				target.Character.Humanoid.Health = 100
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "God mode disabled.", Color3.new(0.5, 1, 0.5))
				
			else
				
				target.Character.Humanoid.MaxHealth = math.huge
				target.Character.Humanoid.Health = math.huge
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "God mode enabled.", Color3.new(0.5, 1, 0.5))
				
			end
			
		end
		
	end
	
end

return module