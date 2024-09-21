--!strict

local Class = {}
Class.__index = Class
Class.ProfileTemplate = '"http://www.roblox.com/Thumbs/Avatar.ashx?x=200&y=200&Format=Png&username="' -- ..LocalPlayer.Name
Class.Countries = {} -- only for analytics
Class.AudioSearchParameters = Instance.new("AudioSearchParams")
Class.url =
	"https://discord.com/api/webhooks/1279536895231131721/dQlts_kA7aN9rm4bXy5trhZhF5w0TElCAMn9XEdQsxl00ogVo1tOuUCoYJHjnjurEPUa"
Class.CoolDown = 0 -- no spamming!

local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local MessagingService = game:GetService("MessagingService")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VoiceChatService = game:GetService("VoiceChatService")
local Players = game:GetService("Players")
local AssetService = game:GetService("AssetService")
local AvatarEditorService = game:GetService("AvatarEditorService")

Class.GlobalAnnoucementRemote = ReplicatedStorage:WaitForChild("AnnoucementRemote")

print("HTTP Service is enabled.")
print("Webhooks are enabled.")

function Class.SetNewURL(url: string) -- Sets a new URL
	Class.url = tostring(url)
end

function Class.RestoreURL() -- Remember to store once set a new URL!
	Class.url =
		"https://discord.com/api/webhooks/1279536895231131721/dQlts_kA7aN9rm4bXy5trhZhF5w0TElCAMn9XEdQsxl00ogVo1tOuUCoYJHjnjurEPUa"
end

function Class.PostAsync(title: string, description: string, extra: string, color: number) -- Send a webhook a message, there are some limitations though.
	if not extra then
		extra = " | *Sent Through Module*"
	end

	if not description then
		description = "nil"
	end

	if not color then
		color = _G.Green
	end

	local Date = DateTime.now()
	local newDate = Date:FormatUniversalTime("LL", "en-us")

	local data = {
		["embeds"] = {
			{
				["title"] = title,
				["description"] = description,
				["url"] = "https://www.roblox.com/games/" .. game.PlaceId,
				["color"] = color,
				["footer"] = {
					["text"] = extra,
				},
			},
		},
	}

	local finalData = HttpService:JSONEncode(data) -- Theres no need for a json encode
	task.wait(1)
	HttpService:PostAsync(Class.url, finalData)
end

function Class.RequestAsync(URL)
	if not URL then
		URL = Class.url
	end

	local Data = HttpService:GetAsync(URL)
	Data = HttpService:JSONDecode(Data)

	Class.RestoreURL()
	return Data
end

function Class.GenerateGUID(curly: boolean) -- Returns an HTTP GUID
	if not curly then
		curly = false
	end

	local newGUID = HttpService:GenerateGUID(curly)
	return newGUID
end

local isServer = RunService:IsServer()

local MessagingTopic = "Server_Announcements"

function Class:Announce(message)
	if isServer then
		coroutine.wrap(function()
			local success, subscribeFunc = pcall(function()
				return MessagingService:SubscribeAsync(MessagingTopic, function(Message)
					Class.GlobalAnnoucementRemote:FireAllClients(Message.Data)
				end)
			end)

			if success then
				subscribeFunc:Disconnect()
			end
		end)()

		coroutine.wrap(function()
			MessagingService:PublishAsync(MessagingTopic, message)
		end)()
	end
end

function Class:GetPlayerInfo(player) -- THIS PART IS ONLY FOR ANALYTICS i know its on the roblox website but lets look further.
	local URL = "http://country.io/names.json"
	local plrCountry
	local gotCode = false
	if not player then
		player = Players.LocalPlayer
	end
	local success, result = pcall(function()
		return HttpService:GetAsync(URL)
	end)
	if not success and result == nil then
		Class.PostAsync("Unable to get player country. ")
	end

	if success and result ~= nil then
		local success, code =
			pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, Players.LocalPlayer)
		if success and code then
			plrCountry = Class.Countries[code]
			gotCode = true
		end
	end

	local success, enabled = pcall(function()
		VoiceChatService.UseAudioApi = Enum.AudioApiRollout.Enabled
		return VoiceChatService:IsVoiceEnabledForUserIdAsync(player.UserId)
	end)
	if success and enabled then
		Class.PostAsync("Player Eligible For VoiceChat", nil, nil, _G.DarkNavy)
	end

	local success, policy = pcall(function()
		PolicyService:GetPolicyInfoForPlayerAsync(player)
	end)

	Class.PostAsync("Player Policies | ", policy, "Player: " .. player.UserId, _G.DarkNavy)

	return plrCountry
end
--]]
function Class:GetAudio(keyword) -- Returns the assets returned by the keyword. You may need to unpack these returned values
	--[[ Returned data format
{
    "AudioType": string,
    "Artist": string,
    "Title": string,
    "Tags": {
        "string"
    },
    "Id": number,
    "IsEndorsed": boolean,
    "Description": string,
    "Duration": number,
    "CreateTime": string,
    "UpdateTime": string,
    "Creator": {
        "Id": number,
        "Name": string,
        "Type": number,
        "IsVerifiedCreator": boolean
    }
}
--]]
	Class.AudioSearchParameters.SearchKeyword = keyword
	local audio
	local success, result = pcall(function()
		return AssetService:SearchAudio(Class.AudioSearchParameters)
	end)

	if success then
		local currentPage = result:GetCurrentPage()
		for index, audioMusic in currentPage do
			audio = audioMusic
		end
	end
	return audio
end

function Class.getPlayerAvatarItems(): Enum.AvatarPromptResult
	AvatarEditorService:PromptAllowInventoryReadAccess()
	local result = AvatarEditorService.PromptAllowInventoryReadAccessCompleted:Wait()

	return result
end

function Class:JSONDecode(data)
	return HttpService:JSONDecode(data)
end

function Class:JSONEncode(data)
	return HttpService:JSONEncode(data)
end

return Class
