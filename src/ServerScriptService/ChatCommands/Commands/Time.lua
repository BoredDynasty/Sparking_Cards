local module = {
	
	["cmd"] = "time",
	["permission"] = "commandtime"
	
}

function module.onCommand(sender, args)
	
	if #args < 3 then
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Usage: /time <hours>:<minutes>:<seconds>", Color3.new(1, 0.5, 0.5))
		
	else
		
		local hour = tonumber(args[1])
		local minute = tonumber(args[2])
		local second = tonumber(args[3])
		
		if hour == nil or minute == nil or second == nil then
			
			game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Invalid time. Must be numbers formatted as hour:minute:second", Color3.new(1, 0.5, 0.5))
			
			return
			
		end
		
		game.Lighting.TimeOfDay = tostring(hour) .. ":" .. tostring(minute) .. ":" .. tostring(second)
		
		game.ReplicatedStorage:FindFirstChild("ChatCommands").Message:FireClient(sender, "Time changed", Color3.new(0.5, 1, 0.5))
		
	end
	
end

return module