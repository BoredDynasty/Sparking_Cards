--Modules
local Holder = script.Parent
local Biome = require(game:GetService("ReplicatedStorage").Classes.Biome)

--Main Folders
local Biomes = Holder.Biomes

--Sources
local PlainsSource = Biomes.Test

local function init()
	Biome:RegisterBiome(PlainsSource, "Test", Color3.fromRGB(222, 255, 6), Color3.fromRGB(75, 109, 30), 1, 0, 0.45, 15)
end

init()