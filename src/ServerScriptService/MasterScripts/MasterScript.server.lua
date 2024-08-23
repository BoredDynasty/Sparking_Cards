--!strict

print("Running The Master Script")
debug.traceback()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")

local RemoteFolder = ReplicatedStorage.RemoteEvents
local CutsceneRemote = RemoteFolder.CutsceneRemote
local PlayCardRemote = RemoteFolder.PlayCard

local Attacks = { Fire = 9, Frost = 5, Plasma = 12, Water = 4 }
local Debounce = {}

local function TakeDamage(victim, attack)
	print("Finding Debounce")
	if not table.find(Debounce, victim) then
		print("Handling Request")
		table.insert(Debounce, victim)
		attack = nil
		local Humanoid = victim.Humanoid
		-- powered by if statements

		if attack == "Fire" then
			attack = Attacks.Fire
		elseif attack == "Frost" then
			attack = Attacks.Frost
		elseif attack == "Plasma" then
			attack = Attacks.Plasma
		elseif attack == "Water" then
			attack = Attacks.Water
		else
			print("This attack doesn't exist")
		end

		if not attack then
			warn("Attack is not found")
			debug.traceback()
			return
		end

		if not Humanoid then
			warn("Humanoid was not found")
			return
		end

		local client = Players:GetPlayerFromCharacter(victim)

		if Humanoid then
			CutsceneRemote:FireClient(client)
			Humanoid:TakeDamage(attack)
		end
		task.wait()
		table.remove(Debounce, 1)
		return attack
	end
end

PlayCardRemote.OnServerEvent:Connect(function(victim, attack)
	if not victim and attack then
		error("? What happened?")
		debug.traceback()
		return
	end

	local rand = math.random(1, 4)

	local client = Players:GetPlayerFromCharacter(victim)
	client.leaderstats.Cards.Value = client.leaderstats.Cards.Value - Attacks[rand]
	-- log an event
	AnalyticsService:LogEconomyEvent(
		client,
		Enum.AnalyticsEconomyFlowType.Sink,
		"Cards",
		rand,
		client.leaderstats.Cards.Value,
		Enum.AnalyticsEconomyTransactionType.Gameplay.Name
	)

	print("You lose  1 - 19 Cards Each Attack.")

	if victim and attack then
		TakeDamage(victim, attack)
	end
end)
