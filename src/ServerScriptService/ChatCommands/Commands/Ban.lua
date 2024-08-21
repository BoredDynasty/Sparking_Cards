local module = {
	
	["cmd"] = "ban",
	["permission"] = "commandban"
	
}

local store = game:GetService("DataStoreService"):GetDataStore("kxAdminBans")

function module.onCommand(sender, args)
	
	if #args == 0 or #args == 1 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /ban <player> <reason>", Color3.new(1, 0.5, 0.5))
		
	else
		
		local success, target = pcall(function()
			
			return game.Players:GetUserIdFromNameAsync(args[1])
			
		end)
		
		if not success then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
			
		else
			
			if script.Parent.Parent.Permissions.IsOp:Invoke(target) then
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "The target player is an operator and cannot be banned.", Color3.new(1, 0.5, 0.5))
				
				return
				
			end
			
			local banned = store:GetAsync(target)
			
			if banned then
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "The target player is already banned.", Color3.new(1, 0.5, 0.5))
				
				return
				
			end
			
			local unfiltered = ""
			
			for i = 2, #args, 1 do
				
				unfiltered = unfiltered .. args[i] .. " "
				
			end
			
			unfiltered = string.sub(unfiltered, 1, string.len(unfiltered) - 1)
			
			local online = game.Players:GetPlayerByUserId(target)
			
			local reason
			
			if online then
				
				reason = game.Chat:FilterStringAsync(unfiltered, sender, online)
				online:Kick(reason)
				
			else
				
				reason = game.Chat:FilterStringForBroadcast(unfiltered, sender)
				
			end
			
			store:SetAsync(target, reason)
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player banned.", Color3.new(0.5, 1, 0.5))
			
		end
		
	end
	
end

return module