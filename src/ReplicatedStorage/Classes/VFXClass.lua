--!nocheck

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local UserInputService = game:GetService("UserInputService")

local UserInputType = require(ReplicatedStorage.Classes.UserInputType)
local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

local Class = {}
Class.__index = Class
Class.Debounce = false
Class.AvaliableVFX = {
	ChargeVFX = ReplicatedStorage.Assets.VFX:FindFirstChild("ChargeVFX"),
}
Class.AvaliableSounds = {
	ChargeVFXSound = ReplicatedStorage.Assets.VFX.Sounds:FindFirstChild("ChargeSound"),
}

function Class.ChargePlayer(key, gameProcessedEvent, player: Player)
	if gameProcessedEvent then
		return
	end

	if key.KeyCode == player:FindFirstChild("Charge_KEY_Ability").Value or key == "Touch" then
		if player:FindFirstChild("CanUseAbilities") == true then
			local Particle = Class.AvaliableVFX.ChargeVFX
			local AnimationStart = "rbxassetid://18900211493"
			Class.Debounce = true
			local Animation = Instance.new("Animation")
			Animation.AnimationId = AnimationStart
			local Track = player.Character:FindFirstChild("Humanoid"):LoadAnimation(Animation)
			Track:Play()
			local Part = Particle:Clone()
			Part.Parent = player.Character:FindFirstChild("Torso")
			Part.CFrame = player.Character:FindFirstChild("Torso").CFrame
			Part.DBZ_Beam_Charge:Play()
			local att = Instance.new("WeldConstraint")
			att.Parent = Part
			att.Part0 = Part
			att.Part1 = player.Character:FindFirstChild("Torso")
			player.Character:FindFirstChild("Torso").Anchored = true
			player.Character:FindFirstChild("Humanoid").WalkSpeed = 0
			task.wait(30)
			Class.Debounce = false
		end
	end
end

function Class.StopChargingPlayer(player: Player)
	local att = player.Character:FindFirstChildOfClass("WeldConstraint")
	local Animation = Instance.new("Animation")
	local Track = player.Character:FindFirstChild("Humanoid"):LoadAnimation(Animation)
	Track:Stop(0.05)
	player.Character:FindFirstChild("Torso").Anchored = false
	player.Character:FindFirstChild("Humanoid").WalkSpeed = 14
	local Part = player.Character:FindFirstChild("Torso").ChargeVFX
	Debris:AddItem(Part, 2)
end

function Class.PlayerHit(VFX: BasePart, player: Player, damageSize: number) -- the "player" is the victim
	local Character = player.Character
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	local CurrentHealth = Humanoid.Health

	local Force = Instance.new("VectorForce")
	Force.Name = "Knockback"
	Force.Force = Vector3.new(HumanoidRootPart.CFrame.LookVector - HumanoidRootPart.CFrame.LookVector)

	local Particles = VFX:FindFirstChildOfClass("ParticleEmitter")
	Particles.Enabled = true
	VFX.Parent = HumanoidRootPart

	local att = Instance.new("WeldConstraint", HumanoidRootPart)
	att.Part0 = HumanoidRootPart
	att.Part1 = VFX

	Humanoid.HealthChanged:Connect(function(health)
		if health < CurrentHealth then
			local Outline = Instance.new("Highlight", Character)
			Outline.Adornee = Character
			Outline.FillColor = Color3.fromHex("#eb4034")
			Outline.OutlineColor = Color3.fromHex("#eb4039")
			Outline.OutlineTransparency = 0.5

			for _, Particle in ServerStorage.Assets.FX:GetDescendants() do
				if Particle:IsA("ParticleEmitter") then
					local newParticle: ParticleEmitter = Particle:Clone()
					newParticle.Parent = HumanoidRootPart
					newParticle:Emit(1)
				end
			end
		end
	end)

	local Particle

	for _, particle in pairs(HumanoidRootPart:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			Particle = particle
		end
	end

	Debris:AddItem(Particle, 0.2)
	Debris:AddItem(Character:FindFirstChildOfClass("Highlight"), 0.2)
	Debris:AddItem(VFX, 2)
	Debris:AddItem(Force, 3)
	Humanoid:TakeDamage(damageSize)
end

function Class.AddDebris(instance: Instance, Time: number) -- schedules an instance for detruction
	Debris:AddItem(instance, Time)
end

function Class.StartListening(player: Player) -- this function uses its own class for listening. isnt that wild?
	local Connection
	player.CharacterAdded:Connect(function(character)
		local UserInput = UserInputType.getInputType()

		local Mouse = player:GetMouse()
		Mouse.KeyDown:Connect(function(key)
			if key == "c" then
				Class.ChargePlayer(key, false, player)
			end
		end)
		if UserInput == "Touch" then
			ContextActionService:BindAction("Charge", function()
				Class.ChargePlayer("Touch", false, player)
			end, true)
			task.spawn(function()
				if player.CanUseAbilities.Value == true then
					ContextActionService:SetDescription("Charge", "Use your Cards to heal your Character.")
					ContextActionService:SetImage("Charge", "rbxassetid://134852700032813") -- sparking cards logo
					ContextActionService:SetPosition("Charge", UDim2.new(0.65, 0.7))
				else
					ContextActionService:UnbindAction("Charge")
				end
			end)
		end
	end)
end

return Class
