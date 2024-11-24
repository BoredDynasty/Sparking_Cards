--[=[
    @class Audio
--]=]
local Audio = {}

-- // Services

local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

-- // Functions

--[=[
    @function Play
        @param sound table
        @param directory Instance?
--]=]
function Audio.Play(sound: string | number, directory)
	if not directory then
		directory = SoundService -- FYI, ReplicatedStorage is kinda client side so, it'll play for the client.
	end
	local audio = nil
	if type(sound) == "string" then
		local any: Sound = directory[sound]
		audio = any:Clone()
		audio.Parent = directory[sound]
		audio:SetAttribute(script.Name, true)
		audio:Play()
		Debris:AddItem(audio, audio.TimeLength)
	elseif type(sound) == "number" then
		audio = Instance.new("Sound", directory)
		audio:SetAttribute(script.Name, true)
		audio.SoundId = sound
		audio:Play()
		Debris:AddItem(audio, audio.TimeLength)
	end
	return audio
end

--[=[
    @function Stop
        @param sound Sound
        @param directory Instance?
--]=]
function Audio.Stop(sound: Sound, directory)
	assert(directory)
	if table.find(directory:GetDescendants(), sound) then
		directory[sound]:Destroy()
		print(`Removing {sound} sound from {directory.Name}.`)
	end
end

return Audio
