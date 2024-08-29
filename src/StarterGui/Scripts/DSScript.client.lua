--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TweenParams = TweenInfo.new(0.1, Enum.EasingStyle.Sine)

local PlayerGui = Players.LocalPlayer.PlayerGui

local SoundFade = TweenInfo.new(5)

local RespawnEvent = game:GetService("ReplicatedStorage").RemoteEvents.RespawnPlayer

local Frame = PlayerGui:WaitForChild("DynamicUI").DeathScreen.Frame
local MessageText = Frame.Message
local PunishmentText = Frame.Punishment

local Messages = {
	"You can do better than that, right?",
	"Hmph. This is getting BORING..!",
	"Well now.",
	"That move wasn't 'Sparking'. ",
	"It's a good thing Albert isn't playing...",
	"Heya, pal, dont do that.",
	"...?",
}
local CardStock = game:GetService("Players").LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Cards")

local Multiplier = CardStock.Value / 5
Players.RespawnTime = math.huge -- hehe

local function TypewriterEffect(textObject, text: string)
	local Text = text
	-- local ticka = script.tick
	for i = 1, #Text do
		textObject.Text = string.sub(Text, 1, i)
		-- ticka:Play()
		task.wait(0.05)
	end
end

local function Cleanup(object, emptyString: string)
	TypewriterEffect(object, emptyString)
	TweenService:Create(Frame.ImageLabel, TweenParams, { ImageColor3 = Color3.fromHex("#FFFFFF") }):Play()
end

-- Now we gotta send a message to the server that the player has to respawn

local function respawn()
	RespawnEvent:FireServer()
end

-- Death Screen
local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

humanoid.Died:Connect(function()
	Cleanup(MessageText, " ")
	Cleanup(PunishmentText, " ")
	Frame.Transparency = 1
	Frame.Visible = true
	TweenService:Create(Frame, TweenParams, { Transparency = 0 }):Play()
	TweenService:Create(Frame.ImageLabel, TweenParams, { ImageTransparency = 0 }):Play()
	TweenService:Create(Frame.ImageLabel, TweenParams, { ImageColor3 = Color3.fromHex("#ff0000") }):Play()
	task.wait(2)
	TypewriterEffect(MessageText, Messages[math.random(1, #Messages)])
	task.wait(5)
	TypewriterEffect(PunishmentText, "You now have " .. math.ceil(Multiplier) .. " Cards Left...")
	CardStock.Value -= CardStock.Value - Multiplier
	task.wait(10)
	Cleanup(MessageText, " ")
	Cleanup(PunishmentText, " ")
	TweenService:Create(Frame, TweenParams, { Transparency = 1 }):Play()
	TweenService:Create(Frame.ImageLabel, TweenParams, { ImageTransparency = 1 }):Play()
	TweenService:Create(Frame.ImageLabel, TweenParams, { ImageColor3 = Color3.fromHex("#000000") }):Play()
	task.wait(0.6)
	Frame.Visible = false
	respawn()
	print("You lose your amount of Cards / 5. Becareful!")
end)
