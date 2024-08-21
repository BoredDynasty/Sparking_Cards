local module = {
	
	["cmd"] = "unban",
	["permission"] = "commandunban"
	
}

local store = game:GetService("DataStoreService"):GetDataStore("kxAdminBans")

function module.onCommand(sender, args)
	
	if #args == 0 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /unban <player>", Color3.new(1, 0.5, 0.5))
		
	else
		
		local success, target = pcall(function()
			
			return game.Players:GetUserIdFromNameAsync(args[1])
			
		end)
		
		if not success then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
			
		else
			
			local banned = store:GetAsync(target)
			
			if not banned then
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "The target player is not banned.", Color3.new(1, 0.5, 0.5))
				
				return
				
			end
			
			store:RemoveAsync(target)
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player unbanned.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module