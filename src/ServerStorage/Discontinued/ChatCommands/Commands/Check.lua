local module = {
	
	["cmd"] = "check",
	["permission"] = "commandcheck"
	
}

local store = game:GetService("DataStoreService"):GetDataStore("kxAdminBans")

function module.onCommand(sender, args)
	
	if #args == 0 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /check <player>", Color3.new(1, 0.5, 0.5))
		
	else
		
		local success, target = pcall(function()
			
			return game.Players:GetUserIdFromNameAsync(args[1])
			
		end)
		
		if not success then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
			
		else
			
			local banned = store:GetAsync(target)
			
			if banned then
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player is currently banned for: " .. banned, Color3.new(0.5, 1, 0.5))
				
			else
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player is not banned.", Color3.new(1, 0.5, 0.5))
				
			end
			
		end
		
	end
	
end

return module