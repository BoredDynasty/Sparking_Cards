--!nonstrict

-- Master.server.lua

local Terrain = workspace.Terrain
local ChunkSize = 512 -- Size of each chunk (X, Z dimensions)
-- local RegionSizeY = 128 -- Height (Y dimension) of each chunk
local TotalRegionSize = Vector3.new(2048, 128, 2048) -- Total terrain size
local Material = Enum.Material.Grass -- Default terrain material

-- Function to generate terrain in a specific region
local function generateChunk(region)
	local partSize = Vector3.new(4, 4, 4) -- Resolution of terrain generation

	for x = region.Min.X, region.Max.X, partSize.X do
		for z = region.Min.Z, region.Max.Z, partSize.Z do
			local height = math.noise(x * 0.01, z * 0.01) * region.Max.Y -- Simple perlin noise
			Terrain:FillBlock(CFrame.new(x, height / 2, z), partSize, Material)
			print("Generated chunk: ", x, z, region)
		end
	end
end

-- Divide the region into smaller chunks
local function divideTerrain(totalSize, chunkSize)
	local chunks = {}
	for x = 0, totalSize.X - chunkSize, chunkSize do
		for z = 0, totalSize.Z - chunkSize, chunkSize do
			local region = Region3.new(Vector3.new(x, 0, z), Vector3.new(x + chunkSize, totalSize.Y, z + chunkSize))
			print("Divided terrain: ", x, z)
			table.insert(chunks, region)
		end
	end
	return chunks
end

-- Function to generate terrain in parallel
local function generateTerrainInParallel(chunks)
	local threads = {}
	for _, chunk in ipairs(chunks) do
		local thread = coroutine.create(function()
			generateChunk(chunk)

			print("Generated terrain in parallel: ", chunk)
		end)
		table.insert(threads, thread)
	end

	for _, thread in ipairs(threads) do
		coroutine.resume(thread)
	end
end

-- Main function to generate the entire terrain
local function generateTerrain()
	local chunks = divideTerrain(TotalRegionSize, ChunkSize)
	generateTerrainInParallel(chunks)
end

-- Call the main function to generate the terrain
generateTerrain()
