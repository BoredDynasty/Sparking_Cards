--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local UserInputService = game:GetService("UserInputService")

local webhook =
	"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"
local HTTP = game:GetService("HttpService")

print("You can only Donate once.")

local alreadyPressed = false

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
	end

	if input.KeyCode == Enum.KeyCode.Zero then
		if alreadyPressed == false then
			alreadyPressed = true
			local data = {
				["embeds"] = {
					{
						["title"] = "Donation",
						["description"] = Players.LocalPlayer.Name
							.. " has So *gracefully* Donated to / [Sparking Cards](https://www.roblox.com/games/6125133811/SPARKING-CARDS), UserID: "
							.. Players.LocalPlayer.UserId,
						["color"] = 5635967,
					},
				},
			}
			local finalData = HTTP:JSONEncode(data)
			HTTP:PostAsync(webhook, finalData)
			MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, 1906572512)
		end
	end
end)
