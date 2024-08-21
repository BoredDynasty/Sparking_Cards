local animation = script:WaitForChild('Animation')
local humanoid = script.Parent:WaitForChild('Humanoid')
local dance = humanoid:LoadAnimation(animation)
dance:Play()