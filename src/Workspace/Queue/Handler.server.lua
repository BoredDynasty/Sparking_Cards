local leaveButtonEvent = game.ReplicatedStorage.LeaveButton
local teleportPart = workspace.TeleportPart
local billboard = script.Parent.Overhead.BillboardGui
local queue = {}
teleporting = false

--Configuration
local maxPlayers = 2
local title = "BedRoom"

wait()
billboard.Frame.PlayerCount.Text = title.." ("..#queue.."/"..maxPlayers..")"
script.Parent.Overhead.ProximityPrompt.ObjectText = title

local function updatePlayerCount()
	billboard.Frame.PlayerCount.Text = title.." ("..#queue.."/"..maxPlayers..")"
end

script.Parent.Overhead.ProximityPrompt.Triggered:Connect(function(plr)
	if plr.Character then
		if teleporting == false then
			local char = plr.Character
			local duplicate = false
			
			for i=1, #queue do
				if queue[i] == char.Name then
					duplicate = true
				end
			end
			
			if duplicate == false then
				if #queue < maxPlayers then
					table.insert(queue, char.Name)
					leaveButtonEvent:FireClient(plr)
					updatePlayerCount()
				end
				
				plr.CharacterRemoving:Connect(function(char)
					for i = 1, #queue do
						if queue[i] == char.Name then
							table.remove(queue, i)
							updatePlayerCount()
						end
					end
				end)
			end	
			
		end
	end
end)

leaveButtonEvent.OnServerEvent:Connect(function(plr)
	if plr.Character then
		for i = 1, #queue do
			if queue[i] == plr.Character.Name then
				table.remove(queue, i)
				updatePlayerCount()
			end
		end
	end
end)

local function teleportPlayers()
	if #queue > 0 then
		billboard.Frame.Time.Script.Disabled = false
		
		local players = {}
		
		for i=1, #queue do
			
			if game.Players:FindFirstChild(queue[i]) then
				table.insert(players,game.Players:FindFirstChild(queue[i]))
			else
				table.remove(queue, i)
			end
		end
		
		teleporting = true
		repeat wait() until #queue <= 0
		billboard.Frame.Time.Script.Disabled = true
		billboard.Frame.Time.Text = ""
		billboard.Frame.Time.TextColor3 = Color3.new(1,0,0)
		teleporting = false
		
	end
end

while wait() do
	seconds = 25 --How many seconds until teleporting
	for i=1, seconds do
		seconds = seconds - 1
		if billboard.Frame.Time.Script.Disabled == true then
			billboard.Frame.Time.Text = "Teleporting in "..seconds.." seconds"
		end
		wait(1)
	end
	teleportPlayers()
end