local module = {}

local store = game:GetService("DataStoreService"):GetDataStore("kxAdminBans")

function module.register()
	
	game.Players.PlayerAdded:Connect(function(player)
		
		local banned = store:GetAsync(player.UserId)
		
		if banned then
			
			player:Kick(banned)
			
		end
		
	end)
	
end

return module