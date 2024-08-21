local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

-- Make the player crawl when touching a vent.
Players.PlayerAdded:Connect(function(player: Player) 
	for i, Vent in pairs(CollectionService:GetTagged("Vent")) do
		local attribute: boolean = player.Character:WaitForChild("CrawlHandler"):GetAttribute("ForceCrawl")
		local Touching: Part = Vent:FindFirstChild("Bottom")

		Touching.Touched:Connect(function(otherPart: BasePart)
			local hum = otherPart.Parent
			if hum then
				attribute = true
			end
		end)
		Touching.TouchEnded:Connect(function(otherPart: BasePart) 
			local hum = otherPart.Parent
			if hum then
				attribute = false
			end
		end)
	end
end)