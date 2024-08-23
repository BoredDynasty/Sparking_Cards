--!strict
local CollectionService = game:GetService("CollectionService")
local MainTag = "Humanoid"

local Tag = CollectionService:GetTagged(MainTag)

-- Simple, am I right?

for hum, humanoid in pairs(Tag) do
	if humanoid:IsA("Humanoid") then
		local animation: Animation = script.Parent:WaitForChild("Animation")
		local dance = humanoid:LoadAnimation(animation)
		dance:Play()
		while true do
			task.wait(5)
			dance:Play()
		end
	end
end
