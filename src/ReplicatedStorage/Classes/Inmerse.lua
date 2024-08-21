-- CLIENT

local module = {}
module.client = nil
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Debris = game:GetService("Debris")

local ChickynoidModule = ReplicatedFirst.Packages.Chickynoid
local Client = require(ChickynoidModule.Client)
local Enums = require(ChickynoidModule.Enums)
--local ClientChickynoid = require(ChickynoidModule.Client)
local FastSignal = require(ChickynoidModule.Vendor.FastSignal)

--local SeeQuery = require(ReplicatedFirst.Modules.SeeQuery)

local LocalPlayer = Players.LocalPlayer
local Assets = script.Assets

module.Settings = {}
local Settings = module.Settings
-- Pitches used for SFX
Settings.PitchRange = {
	Min = 0.6,
	Max = 1,
}
Settings.FloorDistance = 5
Settings.FootprintLifeTime = 10
-- Limbs where rays are casted
Settings.Limbs = {
	LeftFoot = "LeftFoot",
	RightFoot = "RightFoot"
}
-- Determines the CFrames of the attachments used to cast rays and place sounds
Settings.AttachmentCFrames = {
	FootPlant = Assets.AttachmentData.FootPlantOrigin.Value,
	FootstepSFXOrigin = Assets.AttachmentData.FootstepSFXOrigin.Value
}
-- Tracks where the SFX behavior is injected
Settings.WalkingTracks = {
	"Walk",
}
-- Put all materials that should leave footprints
Settings.FootprintMaterials = {
	Enum.Material.Sand,
	Enum.Material.Snow
}

Settings.AdjustFootstepToWalkSpeed = false
Settings.FootstepSpeedScale = 0.8

Settings.UseLegacyPlayBehavior = false
-- This is where all the footprint assets get stored
module.FootprintCache = {}

Settings.DeffaultWalkSFX = "Plastic"

function module:Setup(client)
	
	local function Inject(characterModel)
		-- Wait for characterModel ready
		if not characterModel.modelReady then
			characterModel.onModelCreated:Wait()
		end
		
		local Model = characterModel.model
		local PrimaryPart = characterModel.model.primaryPart
		local LoadedSFX = {} -- sound instances reference table
		local SFXTypeCounter = {} -- counts all sounds loaded :scream:
		local SoundCache = {}
		local JumpSound = nil
		
		-- Create attachments
		local SFXOrigin = Instance.new("Attachment")
		SFXOrigin.Name = "FootstepSFXOrigin"
		SFXOrigin.CFrame = Settings.AttachmentCFrames.FootstepSFXOrigin
		SFXOrigin.Parent = PrimaryPart
		
		local LeftFootPlant = Instance.new("Attachment")
		LeftFootPlant.Name = "LeftFootPlant"
		LeftFootPlant.CFrame = Settings.AttachmentCFrames.FootPlant
		LeftFootPlant.Parent = Model[Settings.Limbs.LeftFoot]
		
		local RightFootPlant = Instance.new("Attachment")
		RightFootPlant.Name = "RightFootPlant"
		RightFootPlant.CFrame = Settings.AttachmentCFrames.FootPlant
		RightFootPlant.Parent = Model[Settings.Limbs.RightFoot]
		-- Load SFX
		for i,Folder in pairs(Assets.FootstepSFX:GetChildren()) do
			
			LoadedSFX[Folder.Name] = {}
			SFXTypeCounter[Folder.Name] = 0
			for i,Sound in pairs(Folder:GetChildren()) do
				SFXTypeCounter[Folder.Name] += 1
				-- Clones sounds into origin attachment
				local SFX = Sound:Clone()
				LoadedSFX[Folder.Name][SFXTypeCounter[Folder.Name]] = SFX
				SFX.Name = SFXTypeCounter[Folder.Name]
				-- Creates pitch FX for variated noices
				local PitchShiftFX = Instance.new("PitchShiftSoundEffect")
				PitchShiftFX.Name = "PitchFX"
				PitchShiftFX.Octave = 1
				PitchShiftFX.Parent = SFX

				SFX.Parent = SFXOrigin
			end
		end
		
		JumpSound = Assets.Other.Jump:Clone()
		JumpSound.Parent = SFXOrigin
		
		-- Inject behavior into all animation tracks related to walking
		for i,TrackName in pairs(Settings.WalkingTracks) do
			local WalkAnim = characterModel.tracks[TrackName]
			-- Check for footstep markers to play SFX and place footprints
			WalkAnim:GetMarkerReachedSignal("Footstep"):Connect(function(FootEnum)
				-- Detect material we are standing on
				local Params = RaycastParams.new()

				local FilteredDescendants = {}

				-- Filters characters from footstep collisions
				local FilteredDescendants = {self.Model}
				for i,Character in pairs(Client.characters) do
					if Character.characterModel then
						if Character.characterModel.model then
							table.insert(FilteredDescendants, Character.characterModel.model)
						end
					end
				end

				table.insert(FilteredDescendants, self.FootprintCache)

				Params.FilterDescendantsInstances = FilteredDescendants
				Params.RespectCanCollide = true
				Params.IgnoreWater = true

				local Origin = PrimaryPart.Position
				local Destination = SFXOrigin.WorldCFrame.Position
				local Direction = (Destination - Origin).Unit

				local Result = workspace:Raycast(Origin ,Direction * Settings.FloorDistance, Params)

				local Position = nil

				if Result then
					Position = Result.Position
					
					local SoundType = Result.Instance.Material.Name
					local Sound = nil
					local Counter = nil
					
					-- if theres no sounds for that material use the deffault SFX library
					if not LoadedSFX[SoundType] then
						SoundType = Settings.DeffaultWalkSFX
						Counter = SFXTypeCounter[SoundType]
						Sound = LoadedSFX[SoundType][Random.new():NextInteger(1,Counter)]
					else
						Counter = SFXTypeCounter[SoundType]
						Sound = LoadedSFX[SoundType][Random.new():NextInteger(1,Counter)]
					end
					
					local PlayingSound = nil
					
					if Settings.UseLegacyPlayBehavior then
						PlayingSound = Sound:Clone()
						PlayingSound.Parent = SFXOrigin
						
						PlayingSound.Ended:Connect(function()
							PlayingSound:Destroy()
						end)
					else
						PlayingSound = Sound
					end

					-- Set random pitch
					if PlayingSound:GetAttribute("UsePitch") then
						if PlayingSound:GetAttribute("UsePitch") == true then
							PlayingSound.PitchFX.Octave = Random.new():NextNumber(PlayingSound:GetAttribute("Min"),PlayingSound:GetAttribute("Max"))
						end
					end
					
					if Settings.AdjustFootstepToWalkSpeed then
						Sound.PlaybackSpeed = WalkAnim.Speed * Settings.FootstepSpeedScale
					end
					
					PlayingSound:Play()

					-- Check if material was a footprint material
					if Settings.FootprintMaterials[Result.Instance.Material] then
						local FootPrintOrigin = nil
						-- Check if its right or left foot
						if FootEnum == "0" then
							FootPrintOrigin = LeftFootPlant.WorldPosition
						else
							FootPrintOrigin = RightFootPlant.WorldPosition
						end
						-- Cast again to determine footprint CFrame
						local FootPrintDirection = Vector3.new(0,-100,0)
						local FootPrintResult = workspace:Raycast(FootPrintOrigin ,FootPrintDirection * Settings.FloorDistance, Params)
						local FootPrintPosition = nil

						if FootPrintResult then
							-- Create new footprint model lol
							FootPrintPosition = FootPrintResult.Position

							local Footprint = Assets.Footprints.Sand:Clone()
							local NewCFrame = CFrame.new(FootPrintPosition)
							NewCFrame = CFrame.lookAt(FootPrintResult.Position, FootPrintResult.Position + FootPrintResult.Normal) * CFrame.Angles(math.rad(-90), 0, 0)
							Footprint.PrimaryPart.CFrame = NewCFrame

							Footprint.Shadow.Color = Result.Instance.Color
							Footprint.Model.Color = Result.Instance.Color
							Footprint.Material = Result.Instance.Material
							-- Add it into the table containing all the models
							table.insert(self.FootprintCache, Footprint)

							Debris:AddItem(Footprint, Settings.FootprintLifeTime)

							Footprint.Parent = workspace
						else
							FootPrintPosition = FootPrintOrigin + FootPrintDirection * Settings.FloorDistance
						end

						--SeeQuery:Ray(true,FootPrintOrigin, FootPrintResult,10)
					end
				end
			end)
		end
		-- Inject to jump animation
		local JumpAnim = characterModel.tracks.Jump
		
		JumpAnim:GetMarkerReachedSignal("Jump"):Connect(function()
			print("JUMPED")
			JumpSound:Play()
		end)
	end
	
	for i,Character in pairs(Client.characters) do
		Inject(Character)
	end
	
	Client.OnCharacterModelCreated:Connect(function(Character)
		Inject(Character)
	end)
end

function module:PlayFaceAnimation()
	
end

function module:GetFootprints()
	return self.Footprints
end
-- Update all inmerse things
function module:Step(client, _deltaTime)
	for i,Character in pairs(Client.characters) do
		if Character.characterModel then
			
			local CharacterData = Character.characterData
			local CharacterModel = Character.characterModel
			
			if CharacterModel.model then
				
			end
		end
	end
end

return module