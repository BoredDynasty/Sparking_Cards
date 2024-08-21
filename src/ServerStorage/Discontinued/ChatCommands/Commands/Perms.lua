local module = {
	
	["cmd"] = "perm"
	
}

local store = game:GetService("DataStoreService"):GetDataStore("kxAdminPerms")

function help(sender)
	
	game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage:", Color3.new(1, 0.5, 0.5))
	game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "/perm user <name> add|remove <perm> - Edit user perms", Color3.new(1, 1, 1))
	game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "/perm user <name> group add|remove <group> - Edit user groups", Color3.new(1, 1, 1)) --5
	game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "/perm user <name> delete - Remove a user's groups and perms", Color3.new(1, 1, 1))
	game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "/perm group <group> add|remove <perm> - Edit group perms", Color3.new(1, 1, 1))
	game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "/perm group <group> create|delete - Edit groups", Color3.new(1, 1, 1))
	
end

function deletePlayer(sender, target)
				
	local success, id = pcall(function()
					
		return game.Players:GetUserIdFromNameAsync(target)
					
	end)
				
	if success then
					
		store:RemoveAsync(id)
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player permissions deleted.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function deleteGroup(sender, target)
	
	local exists = store:GetAsync("g:" .. target)
				
	if exists then
				
		store:RemoveAsync("g:" .. target)
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group deleted.", Color3.new(0.5, 1, 0.5))
				
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function createGroup(sender, target)
	
	local exists = store:getAsync("g:" .. target)
	
	if exists then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group already exists.", Color3.new(1, 0.5, 0.5))
		
	else
	
		store:SetAsync("g:" .. target, "[]")
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group created.", Color3.new(0.5, 1, 0.5))
		
	end
	
end

function addPlayerPerm(sender, target, perm)
	
	local success, id = pcall(function()
		
		return game.Players:GetUserIdFromNameAsync(target)
		
	end)
	
	if success then
	
		local perms = store:GetAsync(id)
		
		if perms == nil then
			
			perms = "[]"
			
		end
		
		local data = game:GetService("HttpService"):JSONDecode(perms)
		
		local exists = false
		
		for _,v in pairs(data) do
			
			if v == string.lower(perm) then
				
				exists = true
				break
				
			end
			
		end
		
		if not exists then
			
			table.insert(data, string.lower(perm))
		
			perms = game:GetService("HttpService"):JSONEncode(data)
		
			store:SetAsync(id, perms)
		
		end
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Permission added.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function removePlayerPerm(sender, target, perm)
	
	local success, id = pcall(function()
		
		return game.Players:GetUserIdFromNameAsync(target)
		
	end)
	
	if success then
	
		local perms = store:GetAsync(id)
		
		if perms == nil then
			
			perms = "[]"
			
		end
		
		local data = game:GetService("HttpService"):JSONDecode(perms)
		
		for k,v in pairs(data) do
			
			if string.lower(v) == string.lower(perm) then
				
				table.remove(data, k)
				break
				
			end
			
		end
		
		perms = game:GetService("HttpService"):JSONEncode(data)
		
		store:SetAsync(id, perms)
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Permission removed.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function addGroupPerm(sender, target, perm)
	
	local exists = store:GetAsync("g:" .. target)
	
	if exists then
	
		local perms = store:GetAsync("g:" .. target)
		
		if perms == nil then
			
			perms = "[]"
			
		end
		
		local data = game:GetService("HttpService"):JSONDecode(perms)
		
		local exists = false
		
		for _,v in pairs(data) do
			
			if v == string.lower(perm) then
				
				exists = true
				break
				
			end
			
		end
		
		if not exists then
			
			table.insert(data, string.lower(perm))
		
			perms = game:GetService("HttpService"):JSONEncode(data)
		
			store:SetAsync("g:" .. target, perms)
		
		end
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Permission added.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function removeGroupPerm(sender, target, perm)
	
	local exists = store:GetAsync("g:" .. target)
	
	if exists then
	
		local perms = store:GetAsync("g:" .. target)
		
		if perms == nil then
			
			perms = "[]"
			
		end
		
		local data = game:GetService("HttpService"):JSONDecode(perms)
		
		for k,v in pairs(data) do
			
			if string.lower(v) == string.lower(perm) then
				
				table.remove(data, k)
				break
				
			end
			
		end
		
		perms = game:GetService("HttpService"):JSONEncode(data)
		
		store:SetAsync("g:" .. target, perms)
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Permission removed.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function addPlayerGroup(sender, target, group)
	
	local exists = store:getAsync("g:" .. group)
	
	if not exists then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group does not exist.", Color3.new(1, 0.5, 0.5))
		
		return
		
	end
	
	local success, id = pcall(function()
		
		return game.Players:GetUserIdFromNameAsync(target)
		
	end)
	
	if success then
	
		local perms = store:GetAsync(id)
		
		if perms == nil then
			
			perms = "[]"
			
		end
		
		local data = game:GetService("HttpService"):JSONDecode(perms)
		
		local exists = false
		
		for _,v in pairs(data) do
			
			if v == "g$" .. string.lower(group) then
				
				exists = true
				break
				
			end
			
		end
		
		if not exists then
			
			table.insert(data, "g$" .. string.lower(group))
		
			perms = game:GetService("HttpService"):JSONEncode(data)
		
			store:SetAsync(id, perms)
		
		end
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group added.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
					
	end

end

function removePlayerGroup(sender, target, group)
	
	local exists = store:getAsync("g:" .. group)
	
	if not exists then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group does not exist.", Color3.new(1, 0.5, 0.5))
		
		return
		
	end
	
	local success, id = pcall(function()
		
		return game.Players:GetUserIdFromNameAsync(target)
		
	end)
	
	if success then
	
		local perms = store:GetAsync(id)
		
		if perms == nil then
			
			perms = "[]"
			
		end
		
		local data = game:GetService("HttpService"):JSONDecode(perms)
		
		for k,v in pairs(data) do
			
			if string.lower(v) == "g$" .. string.lower(group) then
				
				table.remove(data, k)
				break
				
			end
			
		end
		
		perms = game:GetService("HttpService"):JSONEncode(data)
		
		store:SetAsync(id, perms)
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Group removed.", Color3.new(0.5, 1, 0.5))
					
	else
					
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Player does not exist.", Color3.new(1, 0.5, 0.5))
					
	end
	
end

function module.onCommand(sender, args)
	
	if not script.Parent.Parent.Permissions.IsOp:Invoke(sender.UserId) then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Access denied.", Color3.new(1, 0.5, 0.5))
		return
		
	end
	
	if #args == 0 or #args == 1 or #args == 2 then
		
		help(sender)
		
	elseif #args == 3 then
		
		if string.lower(args[1]) == "user" then
			
			if string.lower(args[3]) == "delete" then
				
				deletePlayer(sender, args[2])
				
			else
				
				help(sender)
				
			end
			
		elseif string.lower(args[1]) == "group" then
			
			if string.lower(args[3]) == "delete" then
				
				deleteGroup(sender, args[2])
				
			elseif string.lower(args[3]) == "create" then
				
				createGroup(sender, args[2])
				
			else
				
				help(sender)
				
			end
			
		else
			
			help(sender)
			
		end
		
	elseif #args == 4 then
		
		if string.lower(args[1]) == "user" then
			
			if string.lower(args[3]) == "delete" then
				
				deletePlayer(sender, args[2])
				
			elseif string.lower(args[3]) == "add" then
				
				addPlayerPerm(sender, args[2], args[4])
				
			elseif string.lower(args[3]) == "remove" then
				
				removePlayerPerm(sender, args[2], args[4])
				
			else
				
				help(sender)
				
			end
			
		elseif string.lower(args[1]) == "group" then
			
			if string.lower(args[3]) == "delete" then
				
				deleteGroup(sender, args[2])
				
			elseif string.lower(args[3]) == "create" then
				
				createGroup(sender, args[2])
				
			elseif string.lower(args[3]) == "add" then
				
				addGroupPerm(sender, args[2], args[4])
				
			elseif string.lower(args[3]) == "remove" then
				
				removeGroupPerm(sender, args[2], args[4])
				
			else
				
				help(sender)
				
			end
			
		else
			
			help(sender)
			
		end
		
	else
		
		if string.lower(args[1]) == "user" then
			
			if string.lower(args[3]) == "delete" then
				
				deletePlayer(sender, args[2])
				
			elseif string.lower(args[3]) == "add" then
				
				addPlayerPerm(sender, args[2], args[4])
				
			elseif string.lower(args[3]) == "remove" then
				
				removePlayerPerm(sender, args[2], args[4])
				
			elseif string.lower(args[3]) == "group" then
				
				if string.lower(args[4]) == "add" then
					
					addPlayerGroup(sender, args[2], args[5])
					
				elseif string.lower(args[4]) == "remove" then
					
					removePlayerGroup(sender, args[2], args[5])
					
				end
				
			else
				
				help(sender)
				
			end
			
		elseif string.lower(args[1]) == "group" then
			
			if string.lower(args[3]) == "delete" then
				
				deleteGroup(sender, args[2])
				
			elseif string.lower(args[3]) == "create" then
				
				createGroup(sender, args[2])
				
			elseif string.lower(args[3]) == "add" then
				
				addGroupPerm(sender, args[2], args[4])
				
			elseif string.lower(args[3]) == "remove" then
				
				removeGroupPerm(sender, args[2], args[4])
				
			else
				
				help(sender)
				
			end
			
		else
			
			help(sender)
			
		end
		
	end
	
end

return module