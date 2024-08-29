--!strict
--!nocheck

local Class = {}
Class.ProfileTemplate = '"http://www.roblox.com/Thumbs/Avatar.ashx?x=200&y=200&Format=Png&username="' -- ..LocalPlayer.Name
Class.url =
	"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"

local HttpService = game:GetService("HttpService")

function Class.SetNewURL(url: string) -- Sets a new URL
	Class.url = tostring(url)
end

function Class.RestoreURL() -- Remember to store once set a new URL!
	Class.url =
		"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"
end

function Class.PostAsync(title: string, description: string, extra: string, color: number) -- Send a webhook a message, there are some limitations though.
	if not extra then
		extra = " | *Sent Through Module*"
	end

	if not color then
		color = 5635967
	end

	local data = {
		["embeds"] = {
			{
				["title"] = title,
				["description"] = description .. extra,
				["color"] = tonumber(color),
			},
		},
	}
	local finalData = HttpService:JSONEncode(data)
	task.wait(0.01)
	HttpService:PostAsync(Class.url, finalData)
end

function Class.GenerateGUID(curly: boolean) -- Returns an HTTP GUID
	if not curly then
		curly = false
	end

	local newGUID = HttpService:GenerateGUID(curly)
	return newGUID
end

return Class
