-- [TODO) Start Adding Weapons

-- Weapon.server.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- // Requires // --
-- // Attack Modules // --

local AttackRE = ReplicatedStorage.RemoteEvents.Attack
local GetCardChoice = ReplicatedStorage.RemoteEvents.SendCarcChoice

local cooldown = {}
local playerCards = {} :: {
	[Player]: string,
}

local function catchChoice(player: Player, choice: string)
	playerCards[player] = choice
end

local function findBestCard(player)
	if playerCards[player] == "Fire" then
		return nil
	elseif playerCards[player] == "Frost" then
		return nil
	end
end

local function onAttackBegan(choice: string, mouse: Mouse)
	local player = Players:GetPlayerFromCharacter(mouse.Target.Parent)
	if player then
		if not table.find(cooldown, player) then
			table.insert(cooldown, player)
			task.delay(10, function()
				cooldown[player] = nil
			end)
			local attack = findBestCard(player)
			attack(player, mouse)
		end
	end
end
