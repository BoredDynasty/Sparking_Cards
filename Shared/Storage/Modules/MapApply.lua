--!nonstrict

local Lighting = game:GetService("Lighting")

export type mapConfig = { ["Accesibility"]: {}, ["Lighting"]: {}, ["Model"]: any }

return function(map: mapConfig, player)
	local model = map.Model
	local lightingConfig = map.Lighting
	local easyConfig = map.Accesibility

	local character = player.Character or player.CharacterAdded:Wait()
	character.HumanoidRootPart:MoveTo(math.random(map.Spawns:GetChildren()).CFrame)

	-- // We'll apply the lighting first.

	for key, value in lightingConfig do
		if Lighting[key] then
			Lighting[key] = value
		else
			for _, ppe in Lighting:GetChildren() do
				if ppe[key] and type(ppe[key]) == type(value) then
					ppe[key] = value
				end
			end
		end
		-- // We'll place the map
		model.Parent = game.Workspace
		-- // Make it more easier.
		if easyConfig.Highlights then
			local highlight = Instance.new("Highlight")
			highlight.Parent = character
			highlight.Adornee = character
			highlight.FillTransparency = 0.9
			highlight.OutlineTransparency = 0.8
			highlight.FillColor = Color3.fromRGB(255, 106, 106)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		end
	end
end
