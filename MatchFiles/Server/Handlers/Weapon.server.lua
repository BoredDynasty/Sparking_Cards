-- [TODO) Start Adding Weapons

-- Weapon.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- // Requires // --
-- // Attack Modules // --
local Fire = require(ServerStorage.Modules.Attacks.Frost)

local AttackRE = ReplicatedStorage.RemoteEvents.Attack

local cooldown = {}

-- // Functions
local function iceMagic(player, mouse: Mouse, capability)
	if not table.find(cooldown, player) then
		table.insert(cooldown, player)
		local shardNum: number = 0
		local index: number
		local TInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		local asset = ServerStorage.Assets:FindFirstChild("Fire")
		shardNum, index = Fire(asset, mouse, player, capability, TInfo)
		if index >= shardNum then
			table.remove(cooldown, player)
		end
	end
end

local function chooseFunction(player, mouse: Mouse, capability, name: string)
	print(name)
	if name == "Frost" then
		iceMagic(player, mouse, capability)
	end
end

AttackRE.OnServerEvent:Connect(chooseFunction)
