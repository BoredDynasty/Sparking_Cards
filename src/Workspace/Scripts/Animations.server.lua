--only works for R6
game.Players.PlayerAdded:connect(function(player)
	player.CharacterAdded:connect(function(character)
		task.wait(10)
		player.Character.Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=14512867805"
	end)
end)
