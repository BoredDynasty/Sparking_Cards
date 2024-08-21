--[[
    Scripter: Nyxaris
    Version: 1.0.1
]]

local IconsManager = {}

--// Dependencies
local Modules = script.Parent
local ServiceManager = require(Modules.ServiceManager)
local SettingsManager = require(Modules.SettingsManager)

--// UI Elements
local Players = ServiceManager.Players
local PlayerList = ServiceManager.PlayerList

--// Functions
function IconsManager.IsFriendOfCurrentPlayer(player)
	local currentPlayer = Players.LocalPlayer
	if currentPlayer and currentPlayer ~= player then
		return currentPlayer:IsFriendsWith(player.UserId)
	end
	return false
end

function IconsManager.UpdatePlayerIcon()
	for _, player in pairs(game.Players:GetPlayers()) do
		local playerFrame = PlayerList:FindFirstChild(player.Name .. "_Frame")
		if playerFrame then
			local iconSet = false

			if SettingsManager.Settings.groupRanks.enableGroupRanks and SettingsManager.Settings.groupRanks.groupID then
				local rankInGroup = player:GetRankInGroup(SettingsManager.Settings.groupRanks.groupID)
				if rankInGroup and SettingsManager.GroupRanks[rankInGroup] then
					local rankData = SettingsManager.GroupRanks[rankInGroup]
					playerFrame.PlayerHeader.Icon.Image = rankData.icon
					playerFrame.PlayerHeader.Icon.Visible = true
					iconSet = true
				end
			end

			if not iconSet then
				local isFriend = IconsManager.IsFriendOfCurrentPlayer(player)
				local EF = 17390341
				if isFriend then
					playerFrame.PlayerHeader.Icon.Image = "rbxassetid://14724599020"
					playerFrame.PlayerHeader.Icon.Visible = true
				elseif player:GetRankInGroup(EF) >= 3 then --[[[PLS DON'T DELETE] This shows other players that this game has been joined by the developer 
				who made this PlayerList which serves as a credit]]
					playerFrame.PlayerHeader.Icon.Image = "rbxassetid://14814020650"
					playerFrame.PlayerHeader.Icon.Visible = true
				elseif player.MembershipType == Enum.MembershipType.Premium then
					playerFrame.PlayerHeader.Icon.Image = "rbxassetid://14707170733"
					playerFrame.PlayerHeader.Icon.Visible = true
				end
			end
		end
	end
end

return IconsManager
