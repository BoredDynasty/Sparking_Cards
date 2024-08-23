--!strict
print("Waiting for the Master Script")

task.wait(25)

print("Running the Master Script")
debug.traceback()

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = game:GetService("UserGameSettings")
local AnalyticsService = game:GetService("AnalyticsService")
local ContextActionService = game:GetService("ContextActionService")

local Mouse = Players.LocalPlayer:GetMouse()
local CurrentCamera = game.Workspace.CurrentCamera

local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
local Character = workspace[Players.LocalPlayer.Name]
local Humanoid = Character:FindFirstChild("Humanoid")

if not PlayerGui then
	error("Critical Error", 20)
	return
end

if PlayerGui then -- this whole thing is wrapped in a if statement.
	-- Setup some Conveniency

	local UserSettings = UserSettings()

	local function getGraphicsSetting()
		return UserGameSettings.SavedQualityLevel.Value
	end

	local currentGraphics = getGraphicsSetting()

	local function sendSystemMessage(msg)
		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = tostring(msg),
			Color = Color3.fromRGB(108, 235, 103),
			Font = Enum.Font.BuilderSansBold,
		})
	end

	local SystemMessages = {
		"Stay in the game for 15 Minutes for a prize!",
		"Did you know... actually, im not sure...",
	}

	while true do
		task.wait(math.random(5, 120))
		sendSystemMessage(SystemMessages[math.random(1, #SystemMessages)])
	end

	coroutine.wrap(function()
		local maxTries = 20
		repeat
			local success = pcall(function()
				StarterGui:SetCore("ResetButtonCallback", false)
			end)
			task.wait(0.2)
			maxTries = maxTries - 1
		until success or maxTries == 0
	end)()

	PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeRight

	-- Player Hud -------------------------------------------

	local RankRectOffset = {
		Bronze_I = Vector2.new(30, 50),
		Gold_II = Vector2.new(220, 30),
		Platinum_III = Vector2.new(420, 285),
		Master_IV = Vector2.new(611, 773),
		Sparking_V = Vector2.new(420, 765),
	}

	local TweenParams = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -0.1, true, 0.2)

	local PlayerRank = Players.LocalPlayer:WaitForChild("leaderstats", 50):WaitForChild("Rank", 50)
	local CardsStock = Players.LocalPlayer:WaitForChild("leaderstats", 50):WaitForChild("Cards", 50)

	local name = Players.LocalPlayer.Name
	local displayName = Players.LocalPlayer.DisplayName

	print(
		"We wait 50 Seconds for your DataStore to load. If your DataStore isn't there, it's best to rejoin the server, and do not remove your Focus from the Roblox Client Window whilst loading."
	)

	local RankText = PlayerGui.PlayerHud.Rank.TextLabel
	local RankImage = PlayerGui.PlayerHud.Rank.ImageLabel
	local RankImageShadowColor = PlayerGui.PlayerHud.Frame.Design.dropshadow_square_4
	local UIStroke = RankText.UIStroke

	local ActiveIndicator = PlayerGui.PlayerHud.Frame.ActiveIndicator

	local PlayerImage = PlayerGui.PlayerHud.Frame.PlayerImage
	PlayerImage.Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=200&y=200&Format=Png&username=" .. name

	RankText.Text = tostring(PlayerRank.Value)
	script.Parent.PlayerHud.Frame.CardsStock.Text = tonumber(CardsStock.Value) .. " Cards can be used."

	if RankText.Text == "Bronze I" then
		task.wait(1)
		RankImage.ImageRectOffset = RankRectOffset.Bronze_I
		RankImageShadowColor.ImageColor3 = Color3.fromHex("#63461b")
		UIStroke.Color = Color3.fromHex("#63461b")
	elseif RankText.Text == "Gold II" then
		task.wait(1)
		RankImage.ImageRectOffset = RankRectOffset.Gold_II
		RankImageShadowColor.ImageColor3 = Color3.fromHex("#ffef85")
		UIStroke.Color = Color3.fromHex("#ffef85")
	elseif RankText.Text == "Platinum III" then
		task.wait(1)
		RankImage.ImageRectOffset = RankRectOffset.Platinum_III
		RankImageShadowColor.ImageColor3 = Color3.fromHex("#e3fcff")
		UIStroke.Color = Color3.fromHex("#e3fcff")
	elseif RankText.Text == "Master IV" then
		task.wait(1)
		RankImage.ImageRectOffset = RankRectOffset.Master_IV
		RankImageShadowColor.ImageColor3 = Color3.fromHex("#ff8585")
		UIStroke.Color = Color3.fromHex("#ff8585")
	elseif RankText.Text == "Sparking V" then
		task.wait(1)
		RankImage.ImageRectOffset = RankRectOffset.Sparking_V
		RankImageShadowColor.ImageColor3 = Color3.fromHex("#ff85a9")
		UIStroke.Color = Color3.fromHex("#ff85a9")
	end

	Players.PlayerAdded:Connect(function(player: Player)
		while true do
			task.wait(15)
			RankText.Text = PlayerRank.Value
			task.wait(1) -- roblox powered by if statements
			if RankText.Text == "Bronze I" then
				task.wait(1)
				RankImage.ImageRectOffset = RankRectOffset.Bronze_I
				RankImageShadowColor.ImageColor3 = Color3.fromHex("#63461b")
				UIStroke.Color = Color3.fromHex("#63461b")
			elseif RankText.Text == "Gold II" then
				task.wait(1)
				RankImage.ImageRectOffset = RankRectOffset.Gold_II
				RankImageShadowColor.ImageColor3 = Color3.fromHex("#ffef85")
				UIStroke.Color = Color3.fromHex("#ffef85")
			elseif RankText.Text == "Platinum III" then
				task.wait(1)
				RankImage.ImageRectOffset = RankRectOffset.Platinum_III
				RankImageShadowColor.ImageColor3 = Color3.fromHex("#e3fcff")
				UIStroke.Color = Color3.fromHex("#e3fcff")
			elseif RankText.Text == "Master IV" then
				task.wait(1)
				RankImage.ImageRectOffset = RankRectOffset.Master_IV
				RankImageShadowColor.ImageColor3 = Color3.fromHex("#ff8585")
				UIStroke.Color = Color3.fromHex("#ff8585")
			elseif RankText.Text == "Sparking V" then
				task.wait(1)
				RankImage.ImageRectOffset = RankRectOffset.Sparking_V
				RankImageShadowColor.ImageColor3 = Color3.fromHex("#ff85a9")
				UIStroke.Color = Color3.fromHex("#ff85a9")
			else
				print("Your rank was not found.")
			end
		end
	end)

	PlayerRank.Changed:Connect(function(NewValue)
		print(tostring(displayName) .. " is " .. tostring(NewValue))
		task.wait(1)
		RankText.Text = tostring(NewValue)
		task.wait(1) -- powered by if statements
		if NewValue == "Bronze I" then
			task.wait(1)
			RankImage.ImageRectOffset = RankRectOffset.Bronze_I
			RankImageShadowColor.ImageColor3 = Color3.fromHex("#63461b")
			UIStroke.Color = Color3.fromHex("#63461b")
		elseif NewValue == "Gold II" then
			task.wait(1)
			RankImage.ImageRectOffset = RankRectOffset.Gold_II
			RankImageShadowColor.ImageColor3 = Color3.fromHex("#ffef85")
			UIStroke.Color = Color3.fromHex("#ffef85")
		elseif NewValue == "Platinum III" then
			task.wait(1)
			RankImage.ImageRectOffset = RankRectOffset.Platinum_III
			RankImageShadowColor.ImageColor3 = Color3.fromHex("#e3fcff")
			UIStroke.Color = Color3.fromHex("#e3fcff")
		elseif NewValue == "Master IV" then
			task.wait(1)
			RankImage.ImageRectOffset = RankRectOffset.Master_IV
			RankImageShadowColor.ImageColor3 = Color3.fromHex("#ff8585")
			UIStroke.Color = Color3.fromHex("#ff8585")
		elseif NewValue == "Sparking V" then
			task.wait(1)
			RankImage.ImageRectOffset = RankRectOffset.Sparking_V
			RankImageShadowColor.ImageColor3 = Color3.fromHex("#ff85a9")
			UIStroke.Color = Color3.fromHex("#ff85a9")
		end
	end)

	CardsStock.Changed:Connect(function(NewValue)
		task.wait(1)
		PlayerGui.PlayerHud.Frame.CardsStock.Text = tostring(NewValue)

		while true do -- automatically update
			task.wait(20)
			script.Parent.PlayerHud.Frame.CardsStock.Text =
				tostring(Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Cards").Value)
		end
	end)

	-- Is the player afk?
	UserInputService.WindowFocused:Connect(function()
		TweenService:Create(ActiveIndicator, TweenInfo.new(2), { ImageColor3 = Color3.fromHex("55ff7f") })
	end)

	UserInputService.WindowFocusReleased:Connect(function()
		TweenService:Create(ActiveIndicator, TweenInfo.new(0.2), { ImageColor3 = Color3.fromHex("ff6666") })
	end)

	-- Graphics Block ---------------------------------------------------------------------------------
	local GraphicsBlock = PlayerGui.Graphics.GraphicsBlock

	GraphicsBlock.Visible = true

	while true do
		TweenService:Create(
			GraphicsBlock.TextLabel,
			TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
			{ TextTransparency = 0.8 }
		)
		TweenService:Create(
			GraphicsBlock.TextLabel,
			TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
			{ TextTransparency = 0 }
		)
	end

	RunService.RenderStepped:Connect(function()
		local UserGraphics = getGraphicsSetting()
		if UserGraphics < 5 and UserGraphics ~= currentGraphics then
			print(UserGraphics)
			if not GraphicsBlock.Visible then
				GraphicsBlock.Visible = true
			end
			currentGraphics = UserGraphics
		elseif UserGraphics >= 5 then
			if GraphicsBlock.Visible then
				GraphicsBlock.Visible = false
				currentGraphics = nil
			end
		end
	end)

	-- EmoteGUI -----------------------------------------------------------------------

	local EmoteFrame = PlayerGui.EmoteGUI.HolderFrame
	local Keycode = Enum.KeyCode.Tab

	local function openEmoteFrame()
		local TweenParams = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		EmoteFrame.Visible = true
		TweenService:Create(EmoteFrame, TweenParams, { Position = UDim2.new(0.5, 0, 0.5, 0) })
	end

	local function openEmoteFrameAlt(actionName, inputState, InputObject)
		if inputState == Enum.UserInputState.Begin then
			local TweenParams = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			EmoteFrame.Visible = true
			TweenService:Create(EmoteFrame, TweenParams, { Position = UDim2.new(0.5, 0, 0.5, 0) })
		end
	end

	local function closeEmoteFrame()
		local TweenParams = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		TweenService:Create(EmoteFrame, TweenParams, { Position = UDim2.new(0.5, 0, 0.6, 0) }):Play()
		task.wait(0.195)
		EmoteFrame.Visible = false
	end

	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
		end

		if input.KeyCode == Keycode then
			openEmoteFrame()
		end
	end)

	UserInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
		end

		if input.KeyCode == Keycode then
			closeEmoteFrame()
		end
	end)

	UserGameSettings.Changed:Connect(function(property)
		closeEmoteFrame()
	end)

	ContextActionService:BindAction("Emote", openEmoteFrameAlt, true, nil, Enum.KeyCode.ButtonR1)
	ContextActionService:SetPosition("Emote", UDim2.new(1, -70, 0, 10))

	-- now to make it work
	-- guhhhhhhhhhhhhhhhhhhhhh

	local CurrentAnimation

	local function playAnimation(AnimationID)
		if Character ~= nil and Humanoid ~= nil then
			local AnimationID = "rbxassetid://" .. tostring(AnimationID)
			local OldAnimation = Character:FindFirstChild("LocalAnimation")
			Humanoid.WalkSpeed = 0
			if CurrentAnimation ~= nil then
				CurrentAnimation:Stop()
			end

			if OldAnimation ~= nil then
				if OldAnimation.AnimationId == AnimationID then
					OldAnimation:Destroy()
					Humanoid.WalkSpeed = 14
					return
				end
				OldAnimation:Destroy()
			end

			local Animation = Instance.new("Animation", Character)
			Animation.Name = "LocalAnimation"
			Animation.AnimationId = AnimationID
			CurrentAnimation = Humanoid:LoadAnimation(Animation)
			CurrentAnimation:Play()
			Humanoid.WalkSpeed = 0
		end
	end

	local b1 = EmoteFrame.f1
	local b2 = EmoteFrame.f2
	local b3 = EmoteFrame.f3
	local b4 = EmoteFrame.f4
	local b5 = EmoteFrame.f5
	local b6 = EmoteFrame.f6
	local b7 = EmoteFrame.f7
	local b8 = EmoteFrame.f8

	b1.MouseButton1Down:connect(function()
		playAnimation(b1.AnimID.Value)
		closeEmoteFrame()
	end)

	b2.MouseButton1Down:connect(function()
		playAnimation(b2.AnimID.Value)
		closeEmoteFrame()
	end)

	b3.MouseButton1Down:connect(function()
		playAnimation(b3.AnimID.Value)
		closeEmoteFrame()
	end)

	b4.MouseButton1Down:connect(function()
		playAnimation(b4.AnimID.Value)
		closeEmoteFrame()
	end)

	b5.MouseButton1Down:connect(function()
		playAnimation(b5.AnimID.Value)
		closeEmoteFrame()
	end)

	b6.MouseButton1Down:connect(function()
		playAnimation(b6.AnimID.Value)
		closeEmoteFrame()
	end)

	b7.MouseButton1Down:connect(function()
		playAnimation(b7.AnimID.Value)
		closeEmoteFrame()
	end)

	b8.MouseButton1Down:connect(function()
		playAnimation(b8.AnimID.Value)
		closeEmoteFrame()
	end)

	-- Tool Tip ----------------------------------------------------------------
	local Tooltip: Frame = PlayerGui.ToolTip.ToolTip
	local Offset = UDim2.new(0.015, 0, -0.01, 0)

	-- Normal and Click Detector Tooltips together
	-- ive outdone myself!

	Mouse.Move:Connect(function()
		if Mouse.Target then
			if
				Mouse.Target:FindFirstChild("ClickDetector")
				or Mouse.Target:FindFirstChild("Tooltip") and Mouse.Target:FindFirstChild("Tooltip").Value == true
			then
				Tooltip.NameUI.Text = Mouse.Target.Tooltip:FindFirstChild("Name").Value
				Tooltip.DescUI.Text = Mouse.Target.Tooltip:FindFirstChild("Desc").Value
				local highlight = Instance.new("Highlight", Mouse.Target)
				highlight.Adornee = Mouse.Target
				highlight.FillColor = Color3.fromHex("FFFFFF")
				highlight.OutlineColor = Color3.fromHex("FFFFFF")
				highlight.OutlineTransparency = 0.6
				highlight.FillTransparency = 0.8

				Tooltip.DescUI.RichText = false
				Tooltip.NameUI.RichText = false

				closeEmoteFrame()

				local RichBool = Mouse.Target.Tooltip:FindFirstChildOfClass("BoolValue")

				if RichBool then
					Tooltip.DescUI.RichText = true
					Tooltip.NameUI.RichText = true
				end
				Tooltip.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y) + Offset
				Tooltip.Visible = true
			else
				Tooltip.Visible = false
				Tooltip.DescUI.RichText = false
				Tooltip.NameUI.RichText = false
				local highlight = Mouse.Target:WaitForChild("Highlight")
				if highlight then
					TweenService:Create(highlight, TweenInfo.new(0.1), { OutlineTransparency = 1 })
					TweenService:Create(highlight, TweenInfo.new(0.1), { FillTransparency = 1 })
					task.wait(0.2)
					highlight:Destroy()
				else
					return
				end
			end
		else
			Tooltip.DescUI.RichText = false
			Tooltip.NameUI.RichText = false
			Tooltip.Visible = false
			local highlight = Mouse.Target:WaitForChild("Highlight")
			if highlight then
				TweenService:Create(highlight, TweenInfo.new(0.1), { OutlineTransparency = 1 })
				TweenService:Create(highlight, TweenInfo.new(0.1), { FillTransparency = 1 })
				task.wait(0.2)
				highlight:Destroy()
			else
				return
			end
		end
	end)

	-- Dialogue GUI ---------------------------------------------------------------------
	local DialogueFrame = PlayerGui.DynamicUI.Dialogue.Frame
	local DialogueText = DialogueFrame.DialogueText

	local NewDialogueEvent = ReplicatedStorage.RemoteEvents.NewDialogue

	local function ShowDialogueFrame()
		TweenService:Create(DialogueFrame, TweenParams, { Position = UDim2.new(0, 0, 0.9, 0) }):Play()
	end

	local function HideDialogueFrame()
		TweenService:Create(DialogueFrame, TweenParams, { Position = UDim2.new(0, 0, 1.5, 0) }):Play()
	end

	local function cleanup()
		DialogueText = " "
	end

	local function TypewriterEffect(DisplayedText)
		local Text: string = DisplayedText
		for i = 1, #Text do
			DialogueText.Text = string.sub(DisplayedText, 1, i)
			task.wait(0.05)
		end
	end

	NewDialogueEvent.OnClientEvent:Connect(
		function(Text: string, WaitTime: number, Camera: boolean, CameraPosition: CFrame)
			task.wait(0.1)
			if not WaitTime then
				WaitTime = 5
			end
			if not Text then
				Text = "[INTERNAL SCRIPT ERROR]"
				debug.traceback()
			end

			DialogueText.Text = tostring(Text)
			ShowDialogueFrame()
			closeEmoteFrame()
			task.wait(0.2)

			if Camera == true then
				repeat
					task.wait()
					CurrentCamera.CameraType = Enum.CameraType.Scriptable
				until CurrentCamera.CameraType == Enum.CameraType.Scriptable

				CurrentCamera.CFrame = CameraPosition
				CurrentCamera.CameraType = Enum.CameraType.Custom
			elseif Camera == false then
				CurrentCamera.CameraType = Enum.CameraType.Custom
			end

			task.wait(tonumber(WaitTime))
			HideDialogueFrame()
			task.wait(1)
			cleanup()
		end
	)

	-- Buy Cards GUI ---------------------------------------------------------------------------------------------
	local BuyCardsFrame = PlayerGui.DynamicUI.BuyCards.Frame

	local GiftButton = BuyCardsFrame.Gift
	local BuyButton = BuyCardsFrame.Buy

	local UIGradient = BuyButton.UIStroke.UIGradient -- we are going to make the "buy button" more enticing.

	TweenService:Create(
		UIGradient,
		TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, math.huge, true),
		{ Rotation = 360 }
	):Play()

	local productId = 1904591683

	function promptPurchase()
		MarketplaceService:PromptProductPurchase(Players.LocalPlayer, productId)
		closeEmoteFrame()
	end

	BuyButton.MouseButton1Down:Connect(promptPurchase)
else
	Players.LocalPlayer:Kick("LARGE INTERNAL ERROR....")
end
