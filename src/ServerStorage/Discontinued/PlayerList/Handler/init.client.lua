--[[
    Scripter: Nyxaris
    Version: 1.0.5
]]

--// Dependencies
local Modules = script:FindFirstChild("Modules")
local UIManager = require(Modules.UIManager)
local ServiceManager = require(Modules.ServiceManager)
local SettingsManager = require(Modules.SettingsManager)
local DataManager = require(Modules.DataManager)
local IconsManager = require(Modules.IconsManager)

--// Getting services
local Players, Player, RunService, UserInputService, PlayerList, LeaderstatsFrameTemplate, PlayerFrameTemplate, TeamFrameTemplate, Settings, GroupRanks = ServiceManager.Players, ServiceManager.Player, ServiceManager.RunService, ServiceManager.UserInputService, ServiceManager.PlayerList, ServiceManager.LeaderstatsFrame, ServiceManager.PlayerFrame, ServiceManager.TeamFrame, SettingsManager.Settings, SettingsManager.GroupRanks

--// Setup UI
UIManager.SetupUI()

--// Functions
local function ChangePlayerLeaderstats(Player, PlayerFrame)
	if Settings.leaderstats.enable then
		local Leaderstats = Player:WaitForChild(Settings.leaderstats.folderName, 3)
		if Leaderstats then
			local clonedLeaderstats = {}

			for _, stat in pairs(Leaderstats:GetChildren()) do
				if stat:IsA("ValueBase") then
					local exampleLeaderstats = LeaderstatsFrameTemplate:Clone()
					exampleLeaderstats.Name = stat.Name
					exampleLeaderstats.Parent = PlayerFrame
					exampleLeaderstats.Visible = true

					local statClone = exampleLeaderstats:FindFirstChild("Stats")
					if statClone then
						statClone.Text = DataManager.FormatValue(tostring(stat.Value)) or "-"
					end

					stat:GetPropertyChangedSignal("Value"):Connect(function()
						if statClone then
							statClone.Text = DataManager.FormatValue(tostring(stat.Value)) or "-"
						end
					end)

					table.insert(clonedLeaderstats, exampleLeaderstats)
				end
			end

			for i, clonedLeaderstat in ipairs(clonedLeaderstats) do
				clonedLeaderstat.LayoutOrder = i
			end
		end
	end
end

local function CreatePlayerFrame(Player)
	local TemplatePlayerFrame = PlayerFrameTemplate:Clone()
	TemplatePlayerFrame.Name = Player.Name .. "_Frame"
	TemplatePlayerFrame.Parent = PlayerList

	if Player.Team then
		TemplatePlayerFrame.LayoutOrder = PlayerList[Player.Team.Name].LayoutOrder - 1
	else
		TemplatePlayerFrame.LayoutOrder = PlayerList["Players"].LayoutOrder + 1
	end

	TemplatePlayerFrame.PlayerHeader.PlayerName.Text = Player.Name

	ChangePlayerLeaderstats(Player, TemplatePlayerFrame)

	for _, v in pairs(PlayerList:GetChildren()) do
		if v:IsA("Frame") and v.LayoutOrder >= TemplatePlayerFrame.LayoutOrder and v.Name ~= TemplatePlayerFrame.Name then
			v.LayoutOrder = v.LayoutOrder + 1
		end
	end
end

local function RemovePlayerFrame(Player)
	local PlayerFrame = PlayerList[Player.Name .. "_Frame"]

	for _, v in pairs(PlayerList:GetChildren()) do
		if v:IsA("Frame") and v.LayoutOrder >= PlayerFrame.LayoutOrder and v.Name ~= PlayerFrame.Name then
			v.LayoutOrder = v.LayoutOrder - 1
		end
	end

	PlayerFrame:Destroy()
end

local function UpdatePlayersFrameVisibility()
	local allPlayersHaveTeams = true

	for _, player in pairs(game.Players:GetPlayers()) do
		if not player.Team then
			allPlayersHaveTeams = false
			break
		end
	end

	local PlayersFrame = PlayerList["Players"]
	PlayersFrame.Visible = not allPlayersHaveTeams
end

local function ChangeTeam(Player)
	local success, error = pcall(function()
		local PlayerFrame = PlayerList[Player.Name .. "_Frame"]
		
		for _, v in pairs(PlayerList:GetChildren()) do
			if v:IsA("Frame") and v.LayoutOrder >= PlayerFrame.LayoutOrder and v.Name ~= PlayerFrame.Name then
				v.LayoutOrder = v.LayoutOrder - 1
			end
		end

		if Player.Team then
			PlayerFrame.LayoutOrder = PlayerList[Player.Team.Name].LayoutOrder + 1
		else
			PlayerFrame.LayoutOrder = PlayerList["Players"].LayoutOrder + 1
		end

		UpdatePlayersFrameVisibility()

		PlayerFrame.PlayerHeader.PlayerName.Text = Player.Name

		for _, v in pairs(PlayerList:GetChildren()) do
			if v:IsA("Frame") and v.LayoutOrder >= PlayerFrame.LayoutOrder and v.Name ~= PlayerFrame.Name then
				v.LayoutOrder = v.LayoutOrder + 1
			end
		end
	end)
	
	if not success then
		warn("[CT:Handler]: Unknown error")
	end
end

local function CreateTeamLeaderstats(Team)
	if Settings.leaderstats.enable then
		local TeamFrame = PlayerList:FindFirstChild(Team.Name)
		if TeamFrame then
			local Leaderstats = Player:FindFirstChild(Settings.leaderstats.folderName, 1)
			if Leaderstats then
				for _, stat in pairs(Leaderstats:GetChildren()) do
					if stat:IsA("ValueBase") then
						local exampleLeaderstats = TeamFrame:FindFirstChild(stat.Name)
						if not exampleLeaderstats then
							exampleLeaderstats = LeaderstatsFrameTemplate:Clone()
							exampleLeaderstats.Name = stat.Name
							exampleLeaderstats.Parent = TeamFrame
							exampleLeaderstats.Visible = true
						end

						local statClone = exampleLeaderstats:FindFirstChild("Stats")
						if statClone and statClone:IsA("TextLabel") then
							statClone.Text = DataManager.FormatValue(tostring(stat.Name)) or "-"
						end
					end
				end
			end
		end
	end
end

local function CreateTeamFrame(Team)
	local TemplateTeamFrame = TeamFrameTemplate:Clone()
	TemplateTeamFrame.Name = Team.Name
	TemplateTeamFrame.Parent = PlayerList

	local TeamObject = TemplateTeamFrame:FindFirstChild("TeamHeader")
	TeamObject.TeamName.Text = DataManager.ShortenTextTeamName(Team.Name)
	TeamObject.BackgroundColor3 = Team.TeamColor.Color

	CreateTeamLeaderstats(Team)

	for _, v in pairs(PlayerList:GetChildren()) do
		if v:IsA("Frame") and v.LayoutOrder >= TemplateTeamFrame.LayoutOrder and v.Name ~= TemplateTeamFrame.Name then
			v.LayoutOrder = v.LayoutOrder + 1
		end
	end
end

local function CreateDefaultTeamFrame()
	local Team = {
		Name = "Players",
		TeamColor = Color3.new(0.0509804, 0.0509804, 0.0509804)
	}
	
	local TemplateTeamFrame = TeamFrameTemplate:Clone()
	TemplateTeamFrame.Name = Team.Name
	TemplateTeamFrame.Parent = PlayerList
	TemplateTeamFrame.Visible = false

	local TeamObject = TemplateTeamFrame:FindFirstChild("TeamHeader")
	TeamObject.TeamName.Text = DataManager.ShortenTextTeamName(Team.Name)
	TeamObject.BackgroundColor3 = Team.TeamColor

	CreateTeamLeaderstats(Team)

	for _, v in pairs(PlayerList:GetChildren()) do
		if v:IsA("Frame") and v.LayoutOrder >= TemplateTeamFrame.LayoutOrder and v.Name ~= TemplateTeamFrame.Name then
			v.LayoutOrder = v.LayoutOrder + 1
		end
	end
end

local function UpdatePlayerList()
	for _, v in pairs(game.Players:GetPlayers()) do
		local player = game.Players:GetPlayerByUserId(v.UserId)
		if player and player.Team ~= player.TeamColor then
			ChangeTeam(v)
		end
	end

	for _, v in pairs(game.Teams:GetChildren()) do
		if #v:GetPlayers() == 0 then
			PlayerList[v.Name].Visible = false
		else
			PlayerList[v.Name].Visible = true
		end
	end
end

local function GetVisibleFrames()
	local n = 0
	for i, v in pairs(PlayerList:GetChildren()) do
		if v:IsA("Frame") and v.Visible == true then
			n = n + 1
		end
	end
	return n
end

RunService.Heartbeat:Connect(UpdatePlayerList)
RunService.Heartbeat:Connect(IconsManager.UpdatePlayerIcon)

--// Initial setup
CreateDefaultTeamFrame()

for _, Team in pairs(game:GetService("Teams"):GetTeams()) do
	CreateTeamFrame(Team)
end

for _, Player in pairs(game.Players:GetPlayers()) do
	CreatePlayerFrame(Player)
end

game.Players.PlayerAdded:Connect(function(Player)
	CreatePlayerFrame(Player)
	UpdatePlayersFrameVisibility()
end)

game.Players.PlayerRemoving:Connect(function(Player)
	RemovePlayerFrame(Player)
	UpdatePlayersFrameVisibility()
end)