local module = {
	
	["cmd"] = "burn",
	["permission"] = "commandburn"
	
}

local burning = {}

function module.onCommand(sender, args)
	
	if #args == 0 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /burn <player> [time]", Color3.new(1, 0.5, 0.5))
		
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
			
			local duration = 5
			
			if #args > 1 then
				
				duration = tonumber(args[2])
				if duration == nil then duration = 5 end
				
			end
			
			for _,v in pairs(target.Character:GetChildren()) do
				
				if v:IsA("BasePart") then
					Instance.new("Fire").Parent = v
				end
				
			end
			
			spawn(function()
				
				for i = 1, duration * 10, 1 do
					
					target.Character.Humanoid.Health = target.Character.Humanoid.Health - i
					wait(0.1)
					
					if target.Character.Humanoid.Health == 0 then break end
					
				end
				
				for _,v in pairs(target.Character:GetChildren()) do
				
					if v:IsA("BasePart") then
						v:FindFirstChild("Fire"):Remove()
					end
				
				end
				
			end)
			
			wait()
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Set player on fire.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module