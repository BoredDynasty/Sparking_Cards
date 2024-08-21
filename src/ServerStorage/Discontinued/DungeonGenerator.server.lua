local rooms = 10 --Change this to however many number of rooms you want the dungeon to have

local roomStorage = game.ServerStorage:WaitForChild("DungeonsServerStorage"):WaitForChild("ROOMS")
local doorStorage = game.ServerStorage.DungeonsServerStorage:WaitForChild("DOOR TYPES")


local roomsContainer = Instance.new("Folder")
roomsContainer.Name = "Dungeon"
roomsContainer.Parent = workspace


function createRoom(lastRoom)

	local currentRooms = #roomsContainer:GetChildren()

	if currentRooms < rooms then
		local numRooms = math.random(1, math.clamp(rooms - currentRooms, 1, 4))

		local walls = lastRoom.Walls:GetChildren()

		for i = #walls, 2, -1 do
			local j = Random.new():NextInteger(1, i)
			walls[i], walls[j] = walls[j], walls[i]
		end

		local createdRooms = {}

		for i = 1, numRooms do

			if walls[i] and walls[i]:IsA("Part")  then

				local wallCF = walls[i].CFrame

				local doorsList = doorStorage:GetChildren()
				local newWall = doorsList[math.random(1, #doorsList)]:Clone()
				newWall.CFrame = wallCF
				newWall.Parent = walls[i].Parent

				local wallName = walls[i].Name
				walls[i]:Destroy()


				local roomCFrame = lastRoom.Floor.CFrame + (wallCF.LookVector * lastRoom.Floor.Size.X)
				local isRoom = false

				for x, room in pairs(roomsContainer:GetChildren()) do

					if room.Floor.Position == roomCFrame.Position then
						isRoom = true

						if wallName == "Back Wall" and room.Walls:FindFirstChild("Front Wall") then
							room.Walls["Front Wall"]:Destroy()
						elseif wallName == "Front Wall" and room.Walls:FindFirstChild("Back Wall") then
							room.Walls["Back Wall"]:Destroy()
						elseif wallName == "Left Wall" and room.Walls:FindFirstChild("Right Wall") then
							room.Walls["Right Wall"]:Destroy()
						elseif wallName == "Right Wall" and room.Walls:FindFirstChild("Left Wall") then
							room.Walls["Left Wall"]:Destroy()
						end
					end
				end

				if not isRoom then

					local roomsList = roomStorage:GetChildren()
					local newRoom = roomsList[math.random(1, #roomsList)]:Clone()
					newRoom.PrimaryPart = newRoom.Floor

					newRoom:SetPrimaryPartCFrame(roomCFrame)

					if wallName == "Back Wall" and newRoom.Walls:FindFirstChild("Front Wall") then
						newRoom.Walls["Front Wall"]:Destroy()
					elseif wallName == "Front Wall" and newRoom.Walls:FindFirstChild("Back Wall") then
						newRoom.Walls["Back Wall"]:Destroy()
					elseif wallName == "Left Wall" and newRoom.Walls:FindFirstChild("Right Wall") then
						newRoom.Walls["Right Wall"]:Destroy()
					elseif wallName == "Right Wall" and newRoom.Walls:FindFirstChild("Left Wall") then
						newRoom.Walls["Left Wall"]:Destroy()
					end

					newRoom.Parent = roomsContainer

					table.insert(createdRooms, newRoom)
				end
			end
		end

		for i, createdRoom in pairs(createdRooms) do
			createRoom(createdRoom)
		end
	end
end


local startRoom = roomStorage:WaitForChild("Empty Room"):Clone()
startRoom.PrimaryPart = startRoom.Floor
startRoom:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, startRoom.Floor.Size.Y/2, 0)))

startRoom.Parent = roomsContainer

createRoom(startRoom)