--!native
local discordia = require("discordia")
local client = discordia.Client()

client:on("ready", function()
	print(client.user.tag)
end)

client:on("messageCreate", function(message)
	if message.content == "hello" then
		message:reply("hiya")
	end
end)

client:run(${{ secrets.BOT_KEY }})
