--!nonstrict

local Lighting = game:GetService("Lighting")

export type mapConfig = { ["Accesibility"]: {}, ["Lighting"]: {}, ["Model"]: Model? }

return function(map: mapConfig, player)
	local model = map.Model
	local lightingConfig = map.Lighting
	local easyConfig = map.Accesibility
	-- // We'll apply the lighting first.
	for key, value in lightingConfig do
		Lighting[key] = value
	end
	-- // We'll place the map
	model.Parent = game.Workspace
	-- // Make it more easier.
	if easyConfig.Highlights then
		local character = player.Character or player.CharacterAdded:Wait()
		if character then
			local highlight = Instance.new("Highlight")
			highlight.Parent = character
			highlight.Adornee = character
			highlight.FillTransparency = 0.8
			highlight.FillColor = BrickColor.Red()
			highlight.OutlineColor = BrickColor.White()
		end
	end
end
