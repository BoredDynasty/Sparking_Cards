--Variables--
local Brick = script.Parent
--End--

--Code--
local function PlayerTouched(Part)
	local Parent = Part.Parent
	if game.Players:GetPlayerFromCharacter(Parent) then
		Parent.Humanoid.Health = 0
	end
end

Brick.Touched:connect(PlayerTouched)