local clickDetect = script.Parent.ClickDetector
local altClickDetect = workspace.Testing.LeavePart.ClickDetector

local part = script.Parent

local HapticService = game:GetService("HapticService")

local PlayersInQueue = {}
local Queue1Remote = game.ReplicatedStorage.RemoteEvents.Queue.Queue1

local CameraFocus = require(game.ReplicatedStorage.Classes.CameraPlaneFocus)

local CurrentCam = workspace.CurrentCamera
local billboard = workspace.Testing.CardTable.BillBoardPart.BillboardGui
CurrentCam.CameraType = Enum.CameraType.Scriptable

local folderDetails = part.Details:GetDescendants()

clickDetect.MouseClick:Connect(function(playerWhoClicked: Player)
	if playerWhoClicked.Character then
		playerWhoClicked.Character:PivotTo(script.Parent.CFrame)
	end

	local humanoid = playerWhoClicked.Character:WaitForChild("Humanoid")

	local PlayerName = playerWhoClicked.Name

	if humanoid then
		print("RemovedPlayerWalkspeed(Queue, (" .. playerWhoClicked.DisplayName .. ")")
		humanoid.WalkSpeed = 0
	end
	
	-- Tween Params
	local TInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local tween = game:GetService("TweenService")

	tween:Create(part, TInfo, {Transparency = 1}):Play()
	for _, descendant in pairs(folderDetails) do
		if descendant:IsA("Part") then
			tween:Create(descendant, TInfo, {Transparency = 1}):Play()
		end
	end

	HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 2.5)
	task.wait(0.2)
	HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)

	table.insert(PlayersInQueue, PlayerName)

	local function fireRemote(QueueTable)
		Queue1Remote:FireClient(QueueTable)
	end

	if #PlayersInQueue == 2 then
		local delaytask = task.delay(20, fireRemote(PlayersInQueue))
		if delaytask and #PlayersInQueue == 1 then
			task.cancel(delaytask)
		else
			print("DelayTask was cancelled")
		end
	end
	
end)