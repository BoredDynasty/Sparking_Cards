--!nocheck

local LogService = game:GetService("LogService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local MAX_ERRORS = 10
local TIME_WINDOW = 60

local errorCount = 0
local errorTimestamps = {}

local function resetErrorCount()
	errorCount = 0
	errorTimestamps = {}
end

local function onOutputMessage(message, messageType)
	if messageType == Enum.MessageType.MessageError or Enum.MessageType.MessageWarning then
		-- Record the timestamp of the error
		table.insert(errorTimestamps, tick())
		local debounce = false -- lets not create so much traffic for our precious webhook

		local currentTime = tick()
		while #errorTimestamps > 0 and currentTime - errorTimestamps[1] > TIME_WINDOW do
			table.remove(errorTimestamps, 1)
		end

		errorCount = #errorTimestamps

		if errorCount >= MAX_ERRORS then
			warn("Too many errors detected in the developer console!")
			if debounce == false then
				debounce = true
				ReplicatedStorage.RemoteEvents.SendWebhook:FireServer(
					"Developer Console ",
					"There were way to many errors in the Developer Console. Err; " .. message .. "Errors; #OF_ERR;",
					errorCount,
					tonumber(_G.Red)
				)
				debounce = false
			end
			for index, player in pairs(Players:GetDescendants()) do
				player:Kick(
					"We've detected a substancial increase of Errors within the Developer Console; " .. errorCount
				)
			end
		end
	end
end

LogService.MessageOut:Connect(onOutputMessage)

RunService.Stepped:Connect(function(time, deltaTime)
	if deltaTime > TIME_WINDOW then
		resetErrorCount()
	end
end)