--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local OCUserNotification = require(ServerStorage.Classes.OpenCloud.V2.UserNotification)

local PostClass = require(ReplicatedStorage.Classes.PostClass)

local recipientPlayerID

local Remote = ReplicatedStorage.CreateNotification

-- In the payload, "messageId" is the value of the notification asset ID

Remote.OnServerEvent:Connect(function(player: Player, rank: string)
	local userNotification = {
		payload = {
			messageId = "ccebb131-e662-3244-8685-0fe1caa80658",
			type = "MOMENT",
			parameters = {
				["rank"] = rank,
			},
		},
	}

	local result = OCUserNotification.createUserNotification(recipientPlayerID, userNotification)
	recipientPlayerID = player.UserId

	if result.statusCode ~= 200 then
		print(result.statusCode)
		print(result.error.code)
		print(result.error.message)

		PostClass.PostAsync(
			"Notification Failed ",
			result.statusCode .. result.error.code .. result.error.message,
			"UserID " .. recipientPlayerID,
			10038562 -- red color
		)
	end
end)
