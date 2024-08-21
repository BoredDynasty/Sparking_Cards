--[[
    Scripter: Nyxaris
]]

local ServiceManager = {}

--// Game Services
ServiceManager.Players = game:GetService("Players")
ServiceManager.Player = ServiceManager.Players.LocalPlayer
ServiceManager.RunService = game:GetService("RunService")
ServiceManager.UserInputService = game:GetService("UserInputService")

--// UI Assets
local UI = script.Parent.Parent.Parent
local Script = script.Parent.Parent
ServiceManager.PlayerList = UI:WaitForChild("PlayerList")
ServiceManager.Templates = Script:WaitForChild("Templates")
ServiceManager.LeaderstatsFrame = ServiceManager.Templates:WaitForChild("TemplateLeaderstats")
ServiceManager.PlayerFrame = ServiceManager.Templates:WaitForChild("TemplatePlayer")
ServiceManager.TeamFrame = ServiceManager.Templates:WaitForChild("TemplateTeam")

return ServiceManager