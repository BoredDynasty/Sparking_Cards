if not game.ServerStorage:FindFirstChild("FakeBloxyCola") then
	print("Wrong Settings, Please Read the Description Script!")
end

local a = true
script.Parent.MouseClick:Connect(function()
	if a then
		a = false
		local clone = game.ServerStorage.FakeBloxyCola:Clone()
		clone.Position = script.Parent.Parent.Parent.Parent.Way.ColaPosition.Position
		clone.Parent = workspace
		wait(3)
		a = true
	end
end)