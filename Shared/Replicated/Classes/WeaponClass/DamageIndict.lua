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

local function indict(player: Player, amount, knockback)
	local character = player.Character

	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		humanoid:TakeDamage(amount)
		addEffect(player, amount)
		if knockback then
			coroutine.wrap(function()
				local velocity = Instance.new("BodyVelocity")
				velocity.MaxForce, velocity.Velocity =
					Vector3.new(5e2, 5e2, 5e2), character.HumanoidRootPart.CFrame.LookVector * 70
				velocity.Parent = character
				Debris:AddItem(velocity, 4.1)
			end)()
		end
	end
end

return indict
