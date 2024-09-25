--!strict
--!native
local Axios = require("axios")

local function messageSend()
	Axios.post(
		"https://apis.roblox.com/messaging-service/v1/universes/2232140200/topics/GlobalAnnouncement",
		{ message = "Announcement" },
		{
			headers = {
				["x-api-key"] = ${{ secrets.ROBLOX_GLOBAL_MESSAGING_WEBHOOK_URL }},
				["Content-Type"] = "application/json",
			},
		}
	)
	print("sent?")
end

messageSend()
