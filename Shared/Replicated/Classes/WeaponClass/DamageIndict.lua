--!nonstrict

-- DamageIndict.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local function addEffect(player: Player, amount: number)
	local character = player.Character
	local billboard: BillboardGui = ReplicatedStorage.Assets.DamageIndictUI:Clone()
	billboard.Parent = character.Head
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	billboard.TextLabel.Text = `-{amount} <br></br> <font size="8">{humanoid.Health}</font<`
	Debris:AddItem(billboard, 5)
end

local function indict(player: Player, amount)
	local character = player.Character

	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		humanoid:TakeDamage(amount)
		addEffect(player, amount)
	end
end

return indict
