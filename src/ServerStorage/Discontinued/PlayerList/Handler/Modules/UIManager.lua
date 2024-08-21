--[[
    Scripter: Nyxaris
    Version: 1.0.0
]]

local UIManager = {}

--// Dependencies
local Modules = script.Parent
local ServiceManager = require(Modules.ServiceManager)

--// UI Elements
local UserInputService = ServiceManager.UserInputService
local PlayerList = ServiceManager.PlayerList

--// Functions
function UIManager.SetupUI()
	local success, errorOrResult = pcall(function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

		-- Checking the device
		local isMobile = UserInputService.TouchEnabled
		local isDesktop = UserInputService.KeyboardEnabled
		PlayerList.Visible = not isMobile

		UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Tab then
				UIManager.TogglePlayerList()
			end
		end)
	end)

	if not success then
		warn("[SU:UIManager] Error: " .. tostring(errorOrResult))
	end
end

function UIManager.TogglePlayerList()
	PlayerList.Visible = not PlayerList.Visible
end

return UIManager
