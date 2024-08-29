--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
--[[
local function teleport(player)
	print("Teleported " .. player.DisplayName .. " because game is in Studio Mode")
	local Character = workspace:WaitForChild([player.Name])
	Character.HumanoidRootPart:MoveTo(workspace.testingAreaSpawn.CFrame)
	Character.Humanoid.WalkSpeed = 30
end

Players.PlayerAdded:Connect(function(player)
	if RunService:IsStudio() then
		teleport(player)
	end
end)
--]]
