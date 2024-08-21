require(script.ClientData)()

local players = {}
local cmds = {}
local permissions = {}

for _,v in pairs(script.Commands:GetChildren()) do
	
	local object = require(v)
	
	cmds[object["cmd"]] = object
	permissions[object["cmd"]] = object["permission"]
	
end

game.Players.PlayerAdded:Connect(function(player)
	
	local client = script.Client:Clone()
	client.Parent = player.PlayerGui
	client.Disabled = false
	
	local connection = player.Chatted:Connect(function(message)
		
		if string.sub(message, 1, 1) == "/" then
			
			local cmd = ""
			local args = {}

			for v in string.gmatch(string.sub(message, 2), "%w+") do
				
				if (string.len(cmd) == 0) then
					
					cmd = v
					
				else
					
					table.insert(args, v)
					
				end
				
			end
			
			local cmdobject = cmds[cmd]
			
			if cmdobject == nil then
				
				game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(player, "Unknown command.", Color3.new(1, 0.5, 0.5))
				
			else
				
				if script.Permissions.HasPermission:Invoke(player, permissions[cmd]) then
				
					cmdobject.onCommand(player, args)
				
				else
					
					game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(player, "Access denied.", Color3.new(1, 0.5, 0.5))
					
				end
				
			end

		end
		
	end)
	
	players[player] = connection
	
end)

game.Players.PlayerRemoving:Connect(function(player)
	
	players[player]:Disconnect()
	players[player] = nil
	
end)

for _,v in pairs(script.Listeners:GetChildren()) do
	
	local object = require(v)
	
	object.register()
	
end