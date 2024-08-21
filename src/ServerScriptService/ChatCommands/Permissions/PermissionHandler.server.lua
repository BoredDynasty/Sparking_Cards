local store = game:GetService("DataStoreService"):GetDataStore("kxAdminPerms")

function script.Parent.HasPermission.OnInvoke(player, permission)
	
	if script.Parent.IsOp:Invoke(player.UserId) then
		return true
	end
	
	if permission == nil or string.len(permission) == 0 then
		return true
	end
	
	local json = store:GetAsync(player.UserId)
	
	if json == nil then return false end
	
	local data = game:GetService("HttpService"):JSONDecode(json)
	
	for _,v in pairs(data) do
		
		if string.lower(v) == string.lower(permission) then
			
			return true
			
		elseif string.sub(v, 1, 2) == "g$" then
			
			local group = string.sub(v, 3)
			
			local groupjson = store:GetAsync("g:" .. group)
			
			local groupdata = game:GetService("HttpService"):JSONDecode(groupjson)
			
			for _,p in pairs(groupdata) do
				
				if string.lower(p) == string.lower(permission) then
					
					return true
					
				end
				
			end
			
		end
		
	end
	
	return false
	
end

function script.Parent.IsOp.OnInvoke(id)
	
	for _,v in pairs(script.Parent.Operators:GetChildren()) do
		
		if v.Value == id then
			
			return true
			
		end
		
	end
	
	return false
	
end