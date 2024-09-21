--!strict
local part = script.Parent

local Players = game:GetService("Players")
local Analytics = game:GetService("AnalyticsService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local DialogRE = ReplicatedStorage.RemoteEvents.NewDialogue

local TweenParams = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

for index, Tagged in pairs(CollectionService:GetTagged("ShopPart")) do
	if not Tagged then
		return
	else
		Tagged.Touched:Connect(function(otherPart: BasePart)
			local player = Players:GetPlayerFromCharacter(otherPart.Parent)

			if player then
				local guiShop = player.PlayerGui.DynamicUI.BuyCards
				if Tagged:FindFirstChildOfClass("ObjectValue") then
					local Operator = Tagged:FindFirstChildOfClass("ObjectValue")
					Operator = Operator.Value
					if Operator:HasTag(GlobalSettings.Characters.Obsidian.tag) then
						local Dialog = Operator:GetAttribute("Dialog")
						local Humanoid: Humanoid = Operator:FindFirstChild("Humanoid")
						Humanoid:LoadAnimation("rbxassetid://" .. ServerStorage.RBX_ANIMSAVES.Obsidian:GetAttribute("Anim"))
						print(Dialog)
						DialogRE:FireClient(player, Dialog)
					end
				end
				
				TweenService:Create(guiShop.Frame, TweenParams, { Position = UDim2.new(0.5, 0, 0.901, 0) }):Play()
				Analytics:LogCustomEvent(player, "Player Viewing Gamepass Shop", 2)
			end
		end)

		Tagged.TouchEnded:Connect(function(otherPart: BasePart)
			local player = Players:GetPlayerFromCharacter(otherPart.Parent)
			local guiShop = player.PlayerGui.DynamicUI.BuyCards

			if not player or player then -- ehehehe!
				TweenService:Create(guiShop.Frame, TweenParams, { Position = UDim2.new(0.5, 0, 1.901, 0) }):Play()
				Analytics:LogCustomEvent(player, "Player Exiting Gamepass Shop", 2)
			end
		end)
	end
end
