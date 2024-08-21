local module = {
	
	["cmd"] = "tp",
	["permission"] = "commandtp"
	
}

function module.onCommand(sender, args)
	
	if #args == 0 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /tp <player>", Color3.new(1, 0.5, 0.5))
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /tp <player 1> [player 2]", Color3.new(1, 0.5, 0.5))
		
	elseif #args == 1 then
		
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
			
			sender.Character.PrimaryPart.CFrame = target.Character.PrimaryPart.CFrame
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Teleported.", Color3.new(0.5, 1, 0.5))
			
		end
		
	else
		
		local target1 = nil
		local target2 = nil
		
		for _,v in pairs(game.Players:GetChildren()) do
			
			if string.lower(v.Name) == string.lower(args[1]) then
				target1 = v
				break
			end
			
		end
		
		for _,v in pairs(game.Players:GetChildren()) do
			
			if string.lower(v.Name) == string.lower(args[2]) then
				target2 = v
				break
			end
			
		end
		
		if target1 == nil then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player 1 not found.", Color3.new(1, 0.5, 0.5))
			
		elseif target2 == nil then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player 2 not found.", Color3.new(1, 0.5, 0.5))
			
		else
			
			target1.Character.PrimaryPart.CFrame = target2.Character.PrimaryPart.CFrame
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player teleported.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module