-- This only works on Scripts that are on the Client / Local Scripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundsFolder = ReplicatedStorage.Sounds


-- _G.ReplicatedStorage = ReplicatedStorage
_G.QueueEnterSound = SoundsFolder.QueueEnter
_G.FrameOpenSound = SoundsFolder.FrameOpen
_G.DeniedSound = SoundsFolder.DeniedAccess