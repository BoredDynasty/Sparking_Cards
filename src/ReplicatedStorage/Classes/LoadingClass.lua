--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UIEffectsClass = require(ReplicatedStorage.Modules.UIEffect)
local Curvy = require(ReplicatedStorage.Modules.UIEffect.Curvy)

return function(mapSize, player: Player)
	assert(player, `Player does not exist: {player}`)
	if not mapSize then
		mapSize = 1.5
	end
	local Gui = ReplicatedStorage.LoadingArea

	local f = Gui:Clone()
	f.Parent = player.PlayerGui

	f.Background.Visible = true

	Curvy:Tween(f.Background, nil, f.Background.Position, UDim2.fromScale(0.5, 0.5))
	UIEffectsClass.Sound("ScreenTransition")
	UIEffectsClass:Zoom(true)
	UIEffectsClass.changeColor("Blue", f.Background.Loading.dropshadow_16_20)
	f.Background.Loading.Text = "Connecting..."
	task.wait(mapSize * 0.5)
	f.Background.Loading.Text = "Connected."
	UIEffectsClass.changeColor("Green", f.Background.Loading.dropshadow_16_20)
	task.wait(2)
	Curvy:Tween(f.Background, nil, f.Background.Position, UDim2.fromScale(-2, 0.5))
	UIEffectsClass.Sound("ScreenTransition")
	UIEffectsClass:Zoom(false)
	f:Destroy()

	return mapSize
end
