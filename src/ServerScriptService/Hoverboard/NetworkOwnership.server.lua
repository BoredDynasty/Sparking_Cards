--!strict
local Players = game:GetService("Players")

local function seated(active, seat: Seat)
	if active == false then
		return
	end
	if seat.Name ~= "HoverboardSeat" then
		return
	end

	local player = Players:GetPlayerFromCharacter(seat.Occupant.Parent)
	if player == nil then
		return
	end
	seat:SetNetworkOwner(player)
end

local function characterAdded(character)
	character.Humanoid.Seated:Connect(seated)
end

local function playerAdded(player)
	player.CharacterAdded:Connect(characterAdded)
end

Players.PlayerAdded:Connect(playerAdded)
