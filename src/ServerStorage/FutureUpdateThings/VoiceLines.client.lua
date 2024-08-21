local Char = game.Players.LocalPlayer.Character

local Head = Char:WaitForChild("Head")
local Mouth = Char["Face Decals"].Mouth

local LipSync = "rbxassetid://3256187150"

local VoiceLines = {
	HMPH = Instance.new("Sound");
	Laugh = Instance.new("Sound")
}

VoiceLines.HMPH.SoundId =  "rbxassetid://8064797877"
VoiceLines.Laugh.SoundId = "rbxassetid://3604140002"

