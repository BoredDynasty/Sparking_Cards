while wait() do
	local value = script.Parent.Throttle * 30 -- enter any speed move
	
	script.Parent.Parent.Part["ls3 rev"].Pitch = 1 + script.Parent.Parent.Part.AssemblyLinearVelocity.Magnitude * .01
	-----------------------------------
	script.Parent.Parent.Part.B1.AngularVelocity = value
	script.Parent.Parent.Part.B2.AngularVelocity = value
	script.Parent.Parent.Part.B3.AngularVelocity = value
	script.Parent.Parent.Part.B4.AngularVelocity = value
	
	script.Parent.Parent.Part.A1.AngularVelocity = -value
	script.Parent.Parent.Part.A2.AngularVelocity = -value
	script.Parent.Parent.Part.A3.AngularVelocity = -value
	script.Parent.Parent.Part.A4.AngularVelocity = -value
end

-- GG is work move physical

-- By creator. BadlandGame, Year joined created account. 01/04/2023 and Unlocked age verifty VoiceChat, CameraFace

--Also i smart scripter