local Frost = {}
Frost.__index = Frost

local ServerStorage = game:GetService("ServerStorage")

function Frost:IceLances(player: Player, mouse: Mouse)
	local asset: BasePart = ServerStorage.Assets.IceLances
	local target = mouse.Hit
	local rootPosition = player.Character.HumanoidRootPart.CFrame
	--
end

return Frost
