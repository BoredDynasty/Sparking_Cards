--!strict
local Class = {}
Class.__index = Class
Class.CrossFadeTime = 1
Class.CrossFadeInfo = TweenInfo.new(tonumber(Class.CrossFadeTime))

local TweenService = game:GetService("TweenService")

function Class.SetDefaultSettings(CrossFadeInfo: TweenInfo, CrossFadeTime: number)
	Class.CrossFadeInfo = CrossFadeInfo -- just 1 parameter
	Class.CrossFadeTime = CrossFadeTime
end

function Class.CrossFadeAsync(audio1, audio2, Volume)
	TweenService:Create(audio1, Class.CrossFadeInfo, { Volume = 0 })
	task.wait(0.5421)
	TweenService:Create(audio2, Class.CrossFadeInfo, { Volume = Volume })
end

function ReallyLoudAudioAsync(audio: Sound, parent: any) -- we'll play it for ya!
	audio.Volume = 5
	local a1 = audio:Clone()
	local a2 = audio:Clone()
	local a3 = audio:Clone()
	local a4 = audio:Clone()

	a1:Play()
	a2:Play()
	a3:Play()
	a4:Play()

	a1.Parent = parent
	a2.Parent = parent
	a3.Parent = parent
	a4.Parent = parent

	task.wait(audio.TimeLength)
	a1:Destroy()
	a2:Destroy()
	a3:Destroy()
	a4:Destroy()
end

return Class
