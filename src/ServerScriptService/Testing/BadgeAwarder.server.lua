--!strict
local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local Contributers = { Dynasty = 1626161479 }
local ContributerBadge = 2817914035578656

local function awardBadge(player)
	-- Fetch badge information
	local success, badgeInfo = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, ContributerBadge)
	if success then
		-- Confirm that badge can be awarded
		if badgeInfo.IsEnabled then
			-- Award badge
			local awarded, errorMessage = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, ContributerBadge)
			if not awarded then
				PostClass.PostAsync("Error Fetching Badge ", ContributerBadge, errorMessage, 10038562)
			end
		end
	else
		warn("Error while fetching badge info!")
	end
end

Players.PlayerAdded:Connect(function(player)
	task.wait(30)
	local developers = Players:GetPlayerByUserId(Contributers.Dynasty)
	if developers.UserId == player.UserId then
		awardBadge(player)
	end
end)
