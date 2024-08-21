local Chunk = {}

function Chunk:HandleChunk(chunk_holder, density, biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness)
	local Biome = require(script.Parent)
	local BiomeList = Biome.BiomeTable
	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local ModuleFolder = ReplicatedStorage.BiomeModuleStorage
	
	local Handle = chunk_holder:FindFirstChild("Handle")
	Handle.CanCollide = false
	Handle.Transparency = 1
	Handle.Anchored = true
	
	local Size = Handle.Size
	local bottom_left = Handle.Position - (Size/2)
	local top_right= Handle.Position + (Size/2)
	
	local d = density
	if chunk_holder.OverrideDensity.Value > 0 and chunk_holder.OverrideDensity.Value ~= nil then
		d = chunk_holder.OverrideDensity.Value
	end
	d = d * 6
	
	for x = 0, d do
		local x = math.random(bottom_left.X, top_right.X)
		local y = Handle.Position.Y
		local z = math.random(bottom_left.Z, top_right.Z)
		local pos = Vector3.new(x, y, z)

		local Grass = ModuleFolder.Grass.Hitbox
		local g = Grass:Clone()
		g.Parent = chunk_holder
		g.Position = pos
		
		Biome:SetFoliageSettings(g, biome_folder, biome_name, tint_index, grass_color, size_variation, downsizing, grass_thickness, density)
	end
end

return Chunk