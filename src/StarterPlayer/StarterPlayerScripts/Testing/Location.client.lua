local LocationTitle = require(game.ReplicatedStorage.LocationTitle)

local debounce = false

local TouchParams = {
	Subway = workspace.Subway.Touched
}

LocationTitle.Init({
	TweenLengthOther = 1,
	TweenLengthText = 2,
	GUI = script.LocationUI,
	TextFont = Enum.Font.Michroma,
	SongId = "rbxassetid://0",
	Volume = 0.5,                    
})

-- LocationTitle.Play(TouchParams.Subway.Parent.Name, TouchParams.Subway.Parent.LocationDescription.Value)

TouchParams.Subway.Touched:Connect(function(hit, player)
	task.wait(15)
	-- hit.Parent:FindFirstChild("Humanoid")
	if not debounce then

		debounce = true
		
		LocationTitle.Play(TouchParams.Subway.Parent.Name, TouchParams.Subway.Parent.LocationDescription.Value)

		wait(math.huge)

		debounce = false
	end
end)
