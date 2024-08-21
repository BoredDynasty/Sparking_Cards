local Text = script.Parent

local LocalPlayer = game:GetService("Players").LocalPlayer

local PlayerName = game.Players.LocalPlayer.Name

local RankColors = {
	Bronze = Color3.fromHex("#4a3125"),
	Gold = Color3.fromHex("#ffff7f"),
	Platinum = Color3.fromHex("#c8c8c8"),
	Master = Color3.fromHex("#aa55ff"),
	Sparking = Color3.fromHex("#55aaff")
}

game.Players.PlayerAdded:Connect(function(player: Player) 
	local Rank: Folder = LocalPlayer:WaitForChild("leaderstats")
	local RankString: StringValue = Rank:WaitForChild("Rank").Value
	while true do
		task.wait(5)
		Text.Text = tostring(RankString)
	end
	-- Text.Text = 'Stats; <b /> ' .. PlayerName .. ' <b /> <font color="#55aaff">'.. RankString ..'</font> <br /> <font color="#aa0000">Chaotic Coloring</font>'
end)