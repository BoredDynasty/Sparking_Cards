--!strict

-- // Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Analytics = game:GetService("AnalyticsService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

-- // Variables

local AwardClass = require(ReplicatedStorage.Classes.RewardsClass)
local MathClass = require(ReplicatedStorage.Classes.MathClass)

local AwardableTag = CollectionService:GetTagged("Awardable")
local TutorialTag = CollectionService:GetTagged("Tutorial")
local MovingGuiElementTag = CollectionService:GetTagged("AnimatedMovingElement")

for _, Awardable in pairs(AwardableTag) do
	local AwardablePart = Awardable

	AwardablePart.Touched:Once(function(hit)
		local Player = game.Players:GetPlayerFromCharacter(hit.Parent)
		if Player then
			AwardClass.NewReward(Player, 50)
		else
			print("?")
		end
	end)
end

for _, Tutorial in pairs(TutorialTag) do
	local TutorialPart = Tutorial

	TutorialPart.Touched:Once(function(hit)
		local description = TutorialPart:GetAttribute("TutorialDescription")
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		task.wait(0.05)
		repeat
			task.wait()
		until player:FindFirstChild("PlayerGui")
		task.wait(0.05)
		local F = player:FindFirstChild("PlayerGui").Lore.Frame
		F.Rotation = 90 -- just to set up the visuals
		F.Size = UDim2.new(0, 0, 0, 0)
		F.Visible = true
		F.Description.Text = tostring(description)
		TweenService:Create(F, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Rotation = -5 })
			:Play()
		TweenService:Create(
			F,
			TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
			{ Size = UDim2.new(0.31, 0, 0.409, 0) }
		):Play()

		F.Exit.MouseButton1Down:Connect(function()
			TweenService
				:Create(F, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Rotation = -5 })
				:Play()
			TweenService:Create(
				F,
				TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
				{ Size = UDim2.new(0.31, 0, 0.409, 0) }
			):Play()
			F.Description.Text = " "
			F.Visible = false
		end)
	end)
end
--[[
for _, animatedElement in pairs(MovingGuiElementTag) do
	local animated = animatedElement
	local tween = TweenService:Create(
		animated,
		TweenInfo.new(5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut, math.huge, true, 0),
		{
			Position = UDim2.new(
				MathClass.Random(animated.Position.X - 4, animatedElement.Position.X),
				MathClass.Random(animated.Position.Y - 4, animatedElement.Position.Y)
			),
		}
	)
	local stopAllAnimationsEvent = Instance.new("UnreliableRemoteEvent", ReplicatedStorage.RemoteEvents)
	stopAllAnimationsEvent.Name = "StopCurrentUIAnimations"

	local function stopAllAnimations()
		tween:Stop()
	end
	stopAllAnimationsEvent.OnServerEvent:Connect(stopAllAnimations)
end
--]]

for index, humanoid in pairs(CollectionService:GetTagged("Dancing")) do
	if humanoid:IsA("Humanoid") then
		local animation: Animation = script.Parent:WaitForChild("Animation")
		local dance = humanoid:LoadAnimation(animation)
		dance:Play()
		task.spawn(function()
			task.wait(5)
			dance:Play()
		end)
	end
end
