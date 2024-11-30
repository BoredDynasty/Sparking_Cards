--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local TInfo = TweenInfo.new()
local Zone = require(ReplicatedStorage.Modules.Zone)

local zones = {
	["Subway"] = game.Workspace.Zones.Subway,
}

local subwayZone = Zone.new(zones.Subway)

local queuedTweens: { Tween } = {}

local function changeAtmosphere(atmosphere: Atmosphere, color, density, offset, brightness)
	table.insert(queuedTweens, TweenService:Create(atmosphere, TInfo, { Color = color }))
	table.insert(queuedTweens, TweenService:Create(atmosphere, TInfo, { Density = density }))
	table.insert(queuedTweens, TweenService:Create(atmosphere, TInfo, { Offset = offset }))
	table.insert(queuedTweens, TweenService:Create(Lighting.ColorCorrection, TInfo, { Brightness = brightness }))
	for i, tween in ipairs(queuedTweens) do
		tween:Play()
		if i >= #tween then
			for _, _tween in ipairs(queuedTweens) do
				_tween:Destroy()
			end
		end
	end
end

subwayZone.playerEntered:Connect(function(player)
	print(`{player.DisplayName} has entered the Zoooone!`)
	task.spawn(function()
		changeAtmosphere(Lighting.Atmosphere, Color3.fromHex("#ff55ff"), 0.4, 0.131, -0.15)
	end)
end)
