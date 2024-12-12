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

-- Coroutine-based worker function
local function coroutineWorker(chunks)
	for i, chunk in ipairs(chunks) do
		print(`Coroutine worker: `, i, chunk)
		generateChunk(chunk)
	end
end

-- Main script execution
local function loadTerrain()
	local chunks = divideTerrain(TotalRegionSize, ChunkSize)
	local workers = 4 -- Number of concurrent workers
	local threads = {}
	local chunksPerWorker = math.ceil(#chunks / workers)

	for i = 1, workers do
		local startIndex = (i - 1) * chunksPerWorker + 1
		local endIndex = math.min(i * chunksPerWorker, #chunks)
		local chunkSubset = { unpack(chunks, startIndex, endIndex) }

		-- Start a coroutine for each worker
		local thread = coroutine.create(function()
			coroutineWorker(chunkSubset)
			print("New Thread", threads)
		end)
		table.insert(threads, thread)
	end

	-- Run all threads
	for _, thread in ipairs(threads) do
		coroutine.resume(thread)
	end
end

loadTerrain()
