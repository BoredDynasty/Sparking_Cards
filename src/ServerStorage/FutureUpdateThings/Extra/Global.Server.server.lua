-- This only works on Scripts that are on the Server / Normal Scripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundsFolder = ReplicatedStorage.Sounds


-- _G.ReplicatedStorage = ReplicatedStorage
_G.QueueEnterSound = SoundsFolder.QueueEnter
_G.FrameOpenSound = SoundsFolder.FrameOpen