--!strict
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")

type Pair<A, B> = {
	A: A,
	B: B,
	P: Player,
}

local webhook =
	"https://discord.com/api/webhooks/1270220282392739884/VfivnCGrhDxYGnAZ9F8giiq86Nmm9yezVQww9__TF4-UNdQH_B7lCnS8_a9rpO5szz05"
local HTTP = game:GetService("HttpService")
