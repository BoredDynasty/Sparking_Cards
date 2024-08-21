local item = game.ServerStorage.BloxyCola

script.Parent.Touched:Connect(function(hit)
	if hit.Parent:FindFirstChild("Humanoid") then
		local chr = hit.Parent
		local plr = game.Players:GetPlayerFromCharacter(chr)
		if not plr.Backpack:FindFirstChild("BloxyCola") and not chr:FindFirstChild("BloxyCola") then
			local citem = item:Clone()
			citem.Parent = chr
			script.Parent:Destroy()
		end
	end
end)