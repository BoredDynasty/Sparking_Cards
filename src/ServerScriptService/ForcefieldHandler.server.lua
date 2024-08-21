local tweenService = game:GetService("TweenService")


for i, descendant in pairs(workspace:GetDescendants()) do
	
	if descendant.Name == "Forcefield" then
		
		local hrps = {}
		
		descendant.Touched:Connect(function(part)
			
			if part.Name == "HumanoidRootPart" and not hrps[part] then
				
				hrps[part] = true
				
				
				local pos = part.Position
				
				local particlePart = script.ParticlePart:Clone()
				particlePart.CFrame = CFrame.new(pos, part.Velocity * 100)
				
				particlePart.Parent = workspace
				
				particlePart.Sound:Play()
				
				
				local pulse = script.Pulse:Clone()
				pulse.Size = Vector3.new(0, 0, 0)
				pulse.CFrame = particlePart.CFrame
				
				pulse.Parent = workspace
				
				local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				
				tweenService:Create(pulse, tweenInfo, {Size = Vector3.new(14.848, 14.848, 0.015)}):Play()
				tweenService:Create(pulse.Decal1, tweenInfo, {Transparency = 1}):Play()
				tweenService:Create(pulse.Decal2, tweenInfo, {Transparency = 1}):Play()
				tweenService:Create(pulse.Light, tweenInfo, {Brightness = 0}):Play()
				
				
				local bv = Instance.new("BodyVelocity", part)

				bv.Velocity = -part.Velocity * 9
				
				bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				
				wait(0.3)
				
				bv:Destroy()
				
				hrps[part] = nil
				
				particlePart.ParticleEmitter.Enabled = false
				particlePart.Sound.Stopped:Wait()
				
				particlePart:Destroy()
				
				wait(0.4)
				pulse:Destroy()
			end
		end)
	end
end