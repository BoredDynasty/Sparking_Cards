--!nocheck

local Class = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local UIEffectsClass = require(ReplicatedStorage.Classes.UIEffectsClass)

local TweenParams = UIEffectsClass:newTweenInfo(0.35, "Sine", "In", 1, false, 0) :: TweenInfo

local Gui = ReplicatedStorage.LoadingArea
local Frame = Gui.Background

--[=[
	Creates a new Loading Screen
	@param mapSize number
	@param player Player
--]=]
function Class.New(mapSize, player: Player)
	if not mapSize then
		mapSize = 1.5
	end

	local f = Gui:Clone()
	f.Parent = player.PlayerGui

	f.Background.Visible = true

	TweenService:Create(f.Background, TweenParams, { Position = UDim2.new(0.5, 0, 0.5, 0) })
	UIEffectsClass.Sound("ScreenTransition")
	UIEffectsClass:Zoom(true)
	UIEffectsClass.changeColor("Blue", f.Background.Loading.dropshadow_16_20)
	f.Background.Loading.Text = "Connecting..."
	task.wait(mapSize * 0.5)
	f.Background.Loading.Text = "Connected."
	UIEffectsClass.changeColor("Green", f.Background.Loading.dropshadow_16_20)
	task.wait(2)
	TweenService:Create(f.Background, TweenParams, { Position = UDim2.new(-2, 0, 0.5, 0) })
	UIEffectsClass.Sound("ScreenTransition")
	UIEffectsClass:Zoom(false)
	f:Destroy()

	return mapSize
end

return Class
