local module = {
	
	["cmd"] = "kick",
	["permission"] = "commandkick"
	
}

function module.onCommand(sender, args)
	
	if #args == 0 or #args == 1 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /kick <player> <reason>", Color3.new(1, 0.5, 0.5))
		
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
			
			if script.Parent.Parent.Permissions.IsOp:Invoke(target.UserId) then
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "The target player is an operator and cannot be kicked.", Color3.new(1, 0.5, 0.5))
				
				return
				
			end
			
			local unfiltered = ""
			
			for i = 2, #args, 1 do
				
				unfiltered = unfiltered .. args[i] .. " "
				
			end
			
			unfiltered = string.sub(unfiltered, 1, string.len(unfiltered) - 1)
			
			local reason = game.Chat:FilterStringAsync(unfiltered, sender, target)
			
			target:Kick(reason)
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player kicked.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module