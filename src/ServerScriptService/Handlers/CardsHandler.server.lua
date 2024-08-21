--!strict
local Container = workspace.CardsContainer
local Card = script.Card

local function CreateCard(container)
	local containerPart = container.Part
	local newCard = Card:Clone()
	newCard.Parent = containerPart

	local RandomPosition = Random.new(math.random(1, 5), math.random(5, 10))

	newCard.Position = Vector3.new(RandomPosition.X, RandomPosition.Y, 0)
end

CreateCard(Container)
