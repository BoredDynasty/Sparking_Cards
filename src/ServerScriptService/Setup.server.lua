--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PostClass = require(ReplicatedStorage.Classes.PostClass)
local GlobalSettings = require(ReplicatedStorage.GlobalSettings)

local a = Instance.new("UnreliableRemoteEvent", ReplicatedStorage)
a.Name = "AnnoucementRemote"
local b = Instance.new("UnreliableRemoteEvent", ReplicatedStorage)
b.Name = "ChatMessageGlobal"
