--!strict
--!nocheck

local Class = {}
Class = Class.__index
Class.ProfileTemplate = '"http://www.roblox.com/Thumbs/Avatar.ashx?x=200&y=200&Format=Png&username="' -- ..LocalPlayer.Name

local HttpService = game:GetService("HttpService")
local URL =
	"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"

function Class.PostAsync(title: string, description: string, extra: string) -- Send a webhook a message, there are some limitations though.
	if not extra then
		extra = " | *Sent Through Module*"
	end

	local data = {
		["embeds"] = {
			{
				["title"] = title,
				["description"] = description .. extra,
				["color"] = 5635967,
			},
		},
	}
	local finalData = HttpService:JSONEncode(data)
	task.wait(0.01)
	HttpService:PostAsync(URL, finalData)
end

function Class.GenerateGUID(curly: boolean)
	if not curly then
		curly = false
	end

	local newGUID = HttpService:GenerateGUID(curly)
	return newGUID
end

return Class
