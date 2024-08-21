-- // Services

local Analytics = game:GetService("AnalyticsService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- // Variables
local playerTime = os.clock()

-- // Functions

local function rewardPlayer(player, multiplier)
	local leaderstats = player:WaitForChild("leaderstats")
	local notification = script.Notification
	
	local defaultMultiplier = 1.5
	local newMultiplier = math.ceil(defaultMultiplier * multiplier) -- we use math.ceil so the player gets the most out of their rewards.
	
	Analytics:LogEconomyEvent(
		player,
		Enum.AnalyticsEconomyFlowType.Source,
		"Cards",
		tonumber(newMultiplier),
		leaderstats.Cards.Value + newMultiplier,
		Enum.AnalyticsEconomyTransactionType.TimedReward.Name
	)
	
	leaderstats.Cards.Value += newMultiplier
	
	notification.Parent = player
	TweenService:Create(notification.Frame, TweenInfo.new(2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 1.5, 0)})
	notification.Frame.TextLabel.Text = "Earnings : " .. tostring(leaderstats.Cards.Value + newMultiplier)
end

Players.PlayerAdded:Connect(function(player: Player) 
	playerTime = os.clock()
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			local timeSpent = os.clock() - playerTime
			
			Analytics:FireCustomEvent(player, 
				"Retention", 
				"TimeSpent", 
				timeSpent
			)
			
			-- // Reward the player
			if timeSpent >= 900 then
				rewardPlayer(player, 5)
			end
		end)
	end)
end)