local descendants = workspace:GetDescendants()

for _, tooltip in pairs(descendants) do
	if tooltip:IsA("ClickDetector") then
		tooltip.CursorIcon = "rbxassetid://16081386298"
	end
end

print("Tool tips have been setup.")