--!strict

print("Running The Master Script")
debug.traceback()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService = game:GetService("AnalyticsService")

local GlobalSettings = require(ReplicatedStorage.GlobalSettings)
local MathClass = require(ReplicatedStorage.Classes.MathClass)
local VFXClass = require(ReplicatedStorage.Classes.VFXClass)
local CardsClass = require(ReplicatedStorage.Shared.Cards)
local PostClass = require(ReplicatedStorage.Classes.PostClass)

local RemoteFolder = ReplicatedStorage.RemoteEvents
local CutsceneRemote = RemoteFolder.CutsceneRemote
local PlayCardRemote = RemoteFolder.PlayCard

local Attacks = GlobalSettings.ValidCards
local Debounce = {}

local AnnounceRemote = Instance.new("RemoteEvent")
AnnounceRemote.Name = "AnnounceRemote"
AnnounceRemote.Parent = ReplicatedStorage

CardsClass:StartListening()
VFXClass.SoundListener()
