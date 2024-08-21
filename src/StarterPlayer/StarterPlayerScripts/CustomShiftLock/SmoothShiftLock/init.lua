--[[

	@ Name: SmoothShiftLock
	@ Author: rixtys
	@ Version: 1.0.9
	
	@ Desc: Smooth shift lock module that adds smoothness to the Roblox's shift lock
	│ @ for this to work, disable the default Roblox's shift lock
	│ @ game.StarterPlayer.EnableMouseLockOption = false
	│ @ and start the custom shift lock module with
	└ @ SmoothShiftLock:Init()
	
	@ Methods = {
		SmoothShiftLock:Init()
		Initializes the module. (Should be done on client and only once)
		
		SmoothShiftLock:IsEnabled()
		Gets ShiftLock's enabled state
		
		module.ToggleShiftLock:Fire(boolean)
		Toogles ShiftLock. (Automatically bind to SHIFT_LOCK_KEYBINDS on initialization)
		
		module.EditConfig:Fire(configName, value)
		Edits the ShiftLock's config. (Line 51)
	}

--]]

local SmoothShiftLock = {}
SmoothShiftLock.__index = SmoothShiftLock;

-- [[ Variables ]]:

--// Services and requires
local Players = game:GetService("Players");
local WorkspaceService = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Maid = require(script.Utils:WaitForChild("Maid"));
local Spring = require(script.Utils:WaitForChild("Spring"));

--// Instances
local LocalPlayer = Players.LocalPlayer;

--// Bindables
local ToggleEvent = script:WaitForChild("ToggleShiftLock");
local EditConfig = script:WaitForChild("EditConfig");

--// Configuration
local config = {
	["CHARACTER_SMOOTH_ROTATION"]   = true,                       --// If your character should rotate smoothly or not
	["MANUALLY_TOGGLEABLE"]         = true,                       --// If the shift lock an be toggled manually by player
	["CHARACTER_ROTATION_SPEED"]    = 3,                          --// How quickly character rotates smoothly
	["TRANSITION_SPRING_DAMPER"]    = 0.7,                        --// Camera transition spring damper, test it out to see what works for you
	["CAMERA_TRANSITION_IN_SPEED"]  = 10,                         --// How quickly locked camera moves to offset position
	["CAMERA_TRANSITION_OUT_SPEED"] = 14,                         --// How quickly locked camera moves back from offset position
	["LOCKED_CAMERA_OFFSET"]        = Vector3.new(1.75, 0.25, 0), --// Locked camera offset
	["LOCKED_MOUSE_ICON"]           =                             --// Locked mouse icon
		"rbxasset://textures/MouseLockedCursor.png",
	["SHIFT_LOCK_KEYBINDS"]         =                             --// Shift lock keybinds
		{Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift}
}

--// Setup
local maid = Maid.new();

-- [[ Functions ]]:

--// Setup smooth shift lock on client (Run once and on a LocalScript)
function SmoothShiftLock:Init()
	local managerMaid = Maid.new();

	managerMaid:GiveTask(LocalPlayer.CharacterAdded:Connect(function()
		self:CharacterAdded();
	end));
end;

--// Character added event function
function SmoothShiftLock:CharacterAdded()
	local self = setmetatable({}, SmoothShiftLock);
	--// Instances
	self.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	self.RootPart = self.Character:WaitForChild("HumanoidRootPart");
	self.Humanoid = self.Character:WaitForChild("Humanoid");
	self.Head = self.Character:WaitForChild("Head");
	--// Other
	self.PlayerMouse = LocalPlayer:GetMouse();
	self.Camera = WorkspaceService.CurrentCamera;
	--// Setup
	self.ENABLED = false;
	self.connectionsMaid = Maid.new();
	self.camOffsetSpring = Spring.new(Vector3.new(0, 0, 0));
	self.camOffsetSpring.Damper = config.TRANSITION_SPRING_DAMPER;
	
	--// Bind keybinds
	self.connectionsMaid:GiveTask(UserInputService.InputBegan:Connect(function(input, gpe)
		if (gpe) or not config.MANUALLY_TOGGLEABLE then return end;

		for _, keyBind in pairs(config.SHIFT_LOCK_KEYBINDS) do
			if (input.KeyCode == keyBind) and (self.Humanoid and self.Humanoid.Health ~= 0) then
				self:ToggleShiftLock(not self.ENABLED);
			end;
		end;
	end));

	--// Update camera offset
	self.connectionsMaid:GiveTask(RunService.RenderStepped:Connect(function()
		if self.Head.LocalTransparencyModifier > 0.6 then return end;
		
		local camCF = self.Camera.CoordinateFrame;
		local distance = (self.Head.Position - camCF.p).magnitude;

		--// Camera offset
		if (distance > 1) then	
			self.Camera.CFrame = (self.Camera.CFrame * CFrame.new(self.camOffsetSpring.Position)); 
			
			if (self.ENABLED) and (UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter) then
				self:SetMouseState(self.ENABLED);
			end;
		end;
	end));
	
	--// Bindables
	self.connectionsMaid:GiveTask(ToggleEvent.Event:Connect(function(toggle: boolean)
		if (self.Humanoid and self.Humanoid.Health ~= 0) then
			self:ToggleShiftLock(toggle);
		end;
	end));
	
	self.connectionsMaid:GiveTask(EditConfig.Event:Connect(function(toChange, value)
		if config[toChange] ~= nil then
			config[toChange] = value;
		end;
	end));
	
	--// On death
	self.connectionsMaid:GiveTask(self.Humanoid.Died:Connect(function()
		self:CharacterDiedOrRemoved();
		return;
	end));
	
	--// On character removing
	self.connectionsMaid:GiveTask(LocalPlayer.CharacterRemoving:Connect(function()
		self:CharacterDiedOrRemoved();
		return;
	end));

	return self;
end;

--// Stop shiftlock upon character death or removal
function SmoothShiftLock:CharacterDiedOrRemoved()
	self:ToggleShiftLock(false);
	
	if self.connectionsMaid ~= nil then
		self.connectionsMaid:Destroy();
	end;
	
	maid:DoCleaning();
end;

--// Return shiftlock enabled state
function SmoothShiftLock:IsEnabled(): boolean
	return self.ENABLED;
end;

--// Set Enum.MouseBehavior to LockCenter or Default depending on shiftlock enabled
function SmoothShiftLock:SetMouseState(enable : boolean)
	UserInputService.MouseBehavior = (enable and Enum.MouseBehavior.LockCenter) or (Enum.MouseBehavior.Default);
end;

--// Change mouse icon depending on shiftlock enabled
function SmoothShiftLock:SetMouseIcon(enable : boolean)
	self.PlayerMouse.Icon = (enable and config.LOCKED_MOUSE_ICON :: string) or "";
end;

--// Tween locked camera offset position
function SmoothShiftLock:TransitionLockOffset(enable : boolean)
	if (enable) then
		self.camOffsetSpring.Speed = config.CAMERA_TRANSITION_IN_SPEED;
		self.camOffsetSpring.Target = config.LOCKED_CAMERA_OFFSET;
	else
		self.camOffsetSpring.Speed = config.CAMERA_TRANSITION_OUT_SPEED;
		self.camOffsetSpring.Target = Vector3.new(0, 0, 0);
	end;
end;

--// Toggle shift lock
function SmoothShiftLock:ToggleShiftLock(enable : boolean)
	assert(typeof(enable) == typeof(false), "Enable value is not a boolean.");
	self.ENABLED = enable;

	self:SetMouseState(self.ENABLED);
	self:SetMouseIcon(self.ENABLED);
	self:TransitionLockOffset(self.ENABLED);
	
	--// Start
	if (self.ENABLED) then
		maid:GiveTask(RunService.RenderStepped:Connect(function(delta)
			if (self.Humanoid and self.RootPart) then 
				self.Humanoid.AutoRotate = not self.ENABLED;
			end;
			
			--// Rotate character
			if (self.ENABLED) then
				if not (self.Humanoid.Sit) and (config.CHARACTER_SMOOTH_ROTATION) then
					local x, y, z = self.Camera.CFrame:ToOrientation();
					self.RootPart.CFrame = self.RootPart.CFrame:Lerp(CFrame.new(self.RootPart.Position) * CFrame.Angles(0, y, 0), delta * 5 * config.CHARACTER_ROTATION_SPEED);
				elseif not (self.Humanoid.Sit) then
					local x, y, z = self.Camera.CFrame:ToOrientation();
					self.RootPart.CFrame = CFrame.new(self.RootPart.Position) * CFrame.Angles(0, y, 0);
				end;
			end;
			
			--// Stop
			if not (self.ENABLED) then 
				maid:Destroy() end;
		end));
	end;
	
	return self;
end;

return SmoothShiftLock;