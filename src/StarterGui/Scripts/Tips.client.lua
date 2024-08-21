local function send(msg)
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = tostring(msg);
		Color = Color3.fromRGB(255, 238, 230);
		Font = Enum.Font.BuilderSansBold
	})	
end

local tips = {
	"Stay in the game for 15 Minutes for a prize!",
}

while true do
	wait(math.random(1, 120))
	send(tips[math.random(1, #tips)])
end