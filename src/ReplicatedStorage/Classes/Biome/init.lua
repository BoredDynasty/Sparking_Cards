local Biome = {
	BiomeTable = {}
}
local Holder = game.Workspace.BiomeModule

--Modules
local ChunkModule = require(script.Chunk)

--Main Folders
local Biomes = Holder.Biomes
local PlainsSource = Biomes.Test

--Foliage Settings
local tweentime = .4
local cooldown_devision = 8
local bend_multiplier = 8

function Biome:SetFoliageSettings(grass, biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness, chunk_density)
	if grass.Name == "Hitbox" then
		local Hitbox = grass
		local Primary = grass.Top
		local Beam = grass.Grass

		Beam.Color = ColorSequence.new(grass_color, tint_index)
		Beam.Width0 = grass_thickness

		if size_variation ~= nil and size_variation ~= 0 then
			if downsizing == nil or downsizing <= 0 then
				downsizing = 1
			end

			local SizeVariation_Y = math.random(Primary.Position.Y - size_variation / downsizing, Primary.Position.Y + size_variation / downsizing)
			Primary.Position = Vector3.new(Primary.Position.X, Primary.Position.Y + SizeVariation_Y, Primary.Position.Z)
		end

		Hitbox.Touched:Connect(function(hit)
			local Humanoid = hit.Parent:FindFirstChild("Humanoid")
			if Humanoid then
				grass:SetAttribute("Touching", true)
			end
		end)

		Hitbox.TouchEnded:Connect(function(hit)
			grass:SetAttribute("Touching", false)
		end)
	end
end

function Biome:RegisterBiome(biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness, chunk_density)
	local IsRegistered = table.find(self.BiomeTable, biome_name)
	if IsRegistered and IsRegistered ~= nil then
		table.insert(self.BiomeTable, IsRegistered, biome_name)
	else
		table.insert(self.BiomeTable, biome_name)
	end

	for i, grass in pairs(biome_folder:GetChildren()) do
		if grass:IsA("Folder") then
			ChunkModule:HandleChunk(grass, chunk_density, biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness)
		end
		
		self:SetFoliageSettings(grass, biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness, chunk_density)
	end
end

function Biome:ConfigureBiome(biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness, chunk_density)
	self:RegisterBiome(biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness, chunk_density)
end

return Biome