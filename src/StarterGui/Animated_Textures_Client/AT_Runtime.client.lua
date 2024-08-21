-- DO NOT DELETE THIS, this script is part of the Animated Textures plugin.

-- This script is required to let textures animate properly, tampering with
-- it may break your animated textures or your game!

-- CoiyoFish 2023, Animated Textures Plugin

---------------------------------------------------------------------------

-- Parse textures so they work properly


function ParseTexture(TextureObject)
	if TextureObject.Texture_Parsed.Value == false then
		local TextureId = TextureObject.Texture_Id.Value
		local TextureAdornee = TextureObject.Texture_Adornee.Value
		if TextureObject.Texture_Adornee.Value == nil then
			TextureObject.Texture_Adornee.Value = TextureObject.Parent
			TextureAdornee = TextureObject.Texture_Adornee.Value
		end
		
		if TextureId == 0 then
			error(TextureAdornee.Name..": Animated texture could not load, empty texture id")
		else
			TextureObject.Texture_Parsed.Value = true

			TextureObject:GetPropertyChangedSignal("Parent"):Connect(function()
				local TS = TextureObject.Texture_Storage:GetChildren()
				for i = 1,#TS do
					if TS[i].Value ~= nil then
						TS[i].Value.Parent = TextureObject.Parent
					end
				end
			end)
			
			local TST = TextureObject.Texture_Storage_Temp:GetChildren()
			for i = 1,#TST do
				if TST[i].Value ~= nil then
					TST[i].Value.Name = "Bulk_Remove_In_Progress"
					TST[i].Value:Remove()
				end
				TST[i]:Remove()
			end
			
			local TXFaces = {}
			local Top = Instance.new("Texture",TextureAdornee)
			local Bottom = Instance.new("Texture",TextureAdornee)
			local Left = Instance.new("Texture",TextureAdornee)
			local Right = Instance.new("Texture",TextureAdornee)
			local Front = Instance.new("Texture",TextureAdornee)
			local Back = Instance.new("Texture",TextureAdornee)

			Top.Face = "Top"
			Bottom.Face = "Bottom"
			Left.Face = "Left"
			Right.Face = "Right"
			Front.Face = "Front"
			Back.Face = "Back"

			table.insert(TXFaces,Top)
			table.insert(TXFaces,Bottom)
			table.insert(TXFaces,Left)
			table.insert(TXFaces,Right)
			table.insert(TXFaces,Front)
			table.insert(TXFaces,Back)

			for i = 1,#TXFaces do
				TXFaces[i].ZIndex = -5
				TXFaces[i].Name = "AT_TextureObject"
				TXFaces[i].Texture = string.format("rbxthumb://type=Asset&id=%s&w=420&h=420",TextureId)
				local Log = Instance.new("ObjectValue",TextureObject.Texture_Storage)
				Log.Name = "AT_Texture_Log"
				Log.Value = TXFaces[i]
				
				TXFaces[i].Transparency = TextureObject.Texture_Transparency.Value
		
				
				TXFaces[i]:GetPropertyChangedSignal("Parent"):Connect(function()
					if TXFaces[i].Parent ~= TextureObject.Parent then
						wait()
						TXFaces[i].Parent = TextureObject.Parent
						TXFaces[i].StudsPerTileU = TextureObject.Texture_Size.Value
						TXFaces[i].StudsPerTileV = TextureObject.Texture_Size.Value
					end
				end)

			end


		end
	end
end
-- Keep track of textures and store them in the local database

-- Record Onload
local TextureDB = {}
local GDescendants = game:GetDescendants()
for i = 1,#GDescendants do
	if GDescendants[i].Name == "Texture_Storage" and GDescendants[i].Parent:IsA("Configuration") then
		table.insert(TextureDB,GDescendants[i].Parent)
	end

end
if #TextureDB == 0 then
	script:Remove()
end

-- Record New
game.DescendantAdded:Connect(function(Child)
	if Child.Name == "Texture_Storage" and Child.Parent:IsA("Configuration") then
		table.insert(TextureDB,Child.Parent)
		local TS = Child.Parent.Texture_Storage:GetChildren()
		for i = 1,#TS do
			if TS[i].Value ~= nil then
				TS[i].Value:Remove()
				TS[i]:Remove()
			end
		end
		Child.Parent:WaitForChild("Texture_Parsed").Value = false
		local TextureObject = Child.Parent
		ParseTexture(TextureObject)
	end
end)

-- Remove Deleted
game.DescendantRemoving:Connect(function(Child)
	if Child.Name == "Texture_Storage" and Child.Parent:IsA("Configuration") then
		local Identify = table.find(TextureDB,Child.Parent)
		if Identify then
			table.remove(TextureDB,Identify)
			local TS = Child.Parent.Texture_Storage:GetChildren()
			for i = 1,#TS do
				if TS[i].Value ~= nil then
					TS[i].Value:Remove()
				end
			end
		end
	end
end)

for i = 1,#TextureDB do
	local TextureObject = TextureDB[i]
	TextureObject:WaitForChild("Texture_Parsed").Value = false
	ParseTexture(TextureObject)
end

local LastCCF = Vector3.new(0,0,0)

-- Texture Runtime

-- Code for optical mode
game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
	for i = 1,#TextureDB do
	if TextureDB[i].Parent:IsA("BasePart") then
			if TextureDB[i].Texture_Optical.Value == true then
		local ListSize = {TextureDB[i].Parent.Size.X,TextureDB[i].Parent.Size.Y,TextureDB[i].Parent.Size.Z}
		table.sort(ListSize, function(a, b)
			return a > b
		end)

				
				local ListSize = {TextureDB[i].Parent.Size.X,TextureDB[i].Parent.Size.Y,TextureDB[i].Parent.Size.Z}
				table.sort(ListSize, function(a, b)
					return a > b
				end)

				local TOB = TextureDB[i]
				local _,WPS = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position)

				local PLRAC = TextureDB[i]:FindFirstAncestor(game.Players.LocalPlayer.Character)

				if WPS == true or game.Players.LocalPlayer:GetMouse().Target == TextureDB[i].Parent or PLRAC then
					if (TextureDB[i].Parent.Position-game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 100+ListSize[1] then
						local TXT3 = TextureDB[i].Texture_Storage:GetChildren()
						local TXDB = TextureDB[i]
						for i = 1,#TXT3 do
			
							if TXT3[i].Value ~= nil and TXDB ~= nil then
						
								TXT3[i].Value.OffsetStudsV += game:GetService("UserInputService"):GetMouseDelta().Y*TXDB:GetAttribute("SeedA")*TXDB.Texture_Optical.Optical_Shift.Value
								TXT3[i].Value.OffsetStudsU += game:GetService("UserInputService"):GetMouseDelta().X*TXDB:GetAttribute("SeedB")*TXDB.Texture_Optical.Optical_Shift.Value
								TXT3[i].Value.StudsPerTileU = TOB.Texture_Size.Value
								TXT3[i].Value.StudsPerTileV = TOB.Texture_Size.Value
							
							end
						end
					end
				else

					if (TextureDB[i].Parent.Position-game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 40+ListSize[1] then
						if (TextureDB[i].Parent.Position-game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 300+ListSize[1] then
							local _,WPS2 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(TextureDB[i].Parent.Size.X*.5,0,0))
							local _,WPS3 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(TextureDB[i].Parent.Size.X*-.5,0,0))

							local _,WPS4 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,TextureDB[i].Parent.Size.Y*.5,0))
							local _,WPS5 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,TextureDB[i].Parent.Size.Y*-.5,0))

							local _,WPS6 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,0,TextureDB[i].Parent.Size.Z*.5))
							local _,WPS7 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,0,TextureDB[i].Parent.Size.Z*-.5))
							if WPS2 == true or  WPS3 == true or  WPS4 == true or  WPS5 == true or  WPS6 == true or  WPS7 == true then
								local TXT3 = TextureDB[i].Texture_Storage:GetChildren()
								local TXDB = TextureDB[i]
								for i = 1,#TXT3 do
									if TXT3[i].Value ~= nil and TXDB ~= nil then
										TXT3[i].Value.OffsetStudsV += game:GetService("UserInputService"):GetMouseDelta().Y*TXDB:GetAttribute("SeedA")*TXDB.Texture_Optical.Optical_Shift.Value
										TXT3[i].Value.OffsetStudsU += game:GetService("UserInputService"):GetMouseDelta().X*TXDB:GetAttribute("SeedB")*TXDB.Texture_Optical.Optical_Shift.Value
										TXT3[i].Value.StudsPerTileU = TOB.Texture_Size.Value
										TXT3[i].Value.StudsPerTileV = TOB.Texture_Size.Value
										
									end
								end
							end 
						end
					end
				end
				
			end
		end 
	end
end)

-- Code for constantly moving mode
while wait() do
	for i = 1,#TextureDB do
		if TextureDB[i].Parent:IsA("BasePart") then
			if TextureDB[i].Texture_Moving.Value == true then
			local ListSize = {TextureDB[i].Parent.Size.X,TextureDB[i].Parent.Size.Y,TextureDB[i].Parent.Size.Z}
			table.sort(ListSize, function(a, b)
				return a > b
			end)
		
				local TOB = TextureDB[i]
				local _,WPS = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position)

				local PLRAC = TextureDB[i]:FindFirstAncestor(game.Players.LocalPlayer.Character)

				if WPS == true or game.Players.LocalPlayer:GetMouse().Target == TextureDB[i].Parent or PLRAC then
					if (TextureDB[i].Parent.Position-game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 100+ListSize[1] then
						local TXT3 = TextureDB[i].Texture_Storage:GetChildren()
						for i = 1,#TXT3 do
							if TXT3[i].Value ~= nil then
							TXT3[i].Value.OffsetStudsV += TOB.Texture_Moving.SpeedB.Value
							TXT3[i].Value.OffsetStudsU += TOB.Texture_Moving.Speed.Value
							TXT3[i].Value.StudsPerTileU = TOB.Texture_Size.Value
							TXT3[i].Value.StudsPerTileV = TOB.Texture_Size.Value
							if TXT3[i].Value.OffsetStudsV > 10000 or TXT3[i].Value.OffsetStudsU > 10000 then
								TXT3[i].Value.OffsetStudsV = 0
								TXT3[i].Value.OffsetStudsU = 0
								
								end
								end
						end
					end
				else
			
					if (TextureDB[i].Parent.Position-game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 40+ListSize[1] then
						if (TextureDB[i].Parent.Position-game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 300+ListSize[1] then
							local _,WPS2 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(TextureDB[i].Parent.Size.X*.5,0,0))
							local _,WPS3 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(TextureDB[i].Parent.Size.X*-.5,0,0))

							local _,WPS4 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,TextureDB[i].Parent.Size.Y*.5,0))
							local _,WPS5 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,TextureDB[i].Parent.Size.Y*-.5,0))

							local _,WPS6 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,0,TextureDB[i].Parent.Size.Z*.5))
							local _,WPS7 = game.Workspace.CurrentCamera:WorldToScreenPoint(TextureDB[i].Parent.Position+Vector3.new(0,0,TextureDB[i].Parent.Size.Z*-.5))
							if WPS2 == true or  WPS3 == true or  WPS4 == true or  WPS5 == true or  WPS6 == true or  WPS7 == true then
								local TXT3 = TextureDB[i].Texture_Storage:GetChildren()
								for i = 1,#TXT3 do
									if TXT3[i].Value ~= nil then
										TXT3[i].Value.OffsetStudsV += TOB.Texture_Moving.SpeedB.Value
										TXT3[i].Value.OffsetStudsU += TOB.Texture_Moving.Speed.Value
										TXT3[i].Value.StudsPerTileU = TOB.Texture_Size.Value
										TXT3[i].Value.StudsPerTileV = TOB.Texture_Size.Value
										if TXT3[i].Value.OffsetStudsV > 10000 or TXT3[i].Value.OffsetStudsU > 10000 then
											TXT3[i].Value.OffsetStudsV = 0
											TXT3[i].Value.OffsetStudsU = 0
										end
									end
								end
							end 
						end
					end
				end
			end
		end
	end
end