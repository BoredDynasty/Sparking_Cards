--!nocheck

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

return function(mapSize, player: Player)
	local any = ReplicatedFirst.Loading

	local loadingUI = any:Clone()
	loadingUI.Parent = player.PlayerGui

	local background = loadingUI.CanvasGroup.Background

	local textIndicator = background.Status.StatusText
	local status = textIndicator.Parent:FindFirstChildOfClass("TextButton")
	local str = "[ ID ]"
	if RunService:IsStudio() then
		textIndicator.Text = "[ TEST ]"
	else
		textIndicator.Text = string.gsub(str, "[ ID ]", game.JobId)
	end

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures, true)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.SelfView, true)

	local publicOffset, publicSize = Vector2.new(442, 152), Vector2.new(36, 36)
	-- local privateOffset, privateSize = Vector2.new(442, 194), Vector2.new(36, 36)

	local imgServer = textIndicator.Parent.TextButton.public

	--imgServer.ImageRectOffset = privateOffset
	--imgServer.ImageRectSize = privateSize
	imgServer.ImageRectOffset = publicOffset
	imgServer.ImageRectSize = publicSize
	--end
	task.wait(mapSize * 2)
	status.Text = "Loaded"
	task.wait(4)
	loadingUI:Destroy()
end
