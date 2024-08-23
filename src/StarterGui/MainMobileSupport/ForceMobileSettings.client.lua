--!strict
local Players = game:GetService("Players")
local playerGUI = Players.LocalPlayer:WaitForChild("PlayerGui")

task.wait(2)

playerGUI.ScreenOrientation = Enum.ScreenOrientation.LandscapeRight
