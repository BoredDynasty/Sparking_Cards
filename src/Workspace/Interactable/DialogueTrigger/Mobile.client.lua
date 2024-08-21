local ContextActionService = game:GetService("ContextActionService")

local Remote = game:GetService("ReplicatedStorage").RemoteEvents.NewDialogue

local db = false

local Dialogue = script.Parent:GetAttribute("DialogueText")
local DissapearTime = script.Parent:GetAttribute("DissapearTime")
local CameraBool = script.Parent:GetAttribute("CameraBool")

local function ViewDialogueMOBILE()
	if db == false then
		db = true
		Remote:FireAllClients(Dialogue, DissapearTime, CameraBool)
		print("Set FireAllClients()")
		task.wait(tonumber(DissapearTime))
		db = false
	end
end

ContextActionService:BindAction("Talk", ViewDialogueMOBILE, true, Enum.UserInputType.Touch)
-- Set button position
