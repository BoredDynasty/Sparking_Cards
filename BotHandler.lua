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

client:run("MTI4MTc4ODYwMjYyNzM5MTU1OQ.GQe9jc.1lMIHl7Vf5xch6uPWXJaNe7VU2Csuk2NxIb-zM")
