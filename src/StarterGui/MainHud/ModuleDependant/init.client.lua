--local ReplicatedStorage = game.ReplicatedStorage
--local SpriteSheetModule = require(ReplicatedStorage.SpriteClip)

--local Image = script.Parent.ImageLabel

--SpriteSheetModule.new(Image, nil, true, 1, Vector2.new(90, 100), Vector2.new(93), 11, 0, 15, nil, true, true)
--[[
local SpriteClip = require(require(SpriteSheetModule))

local SpriteClipObject = SpriteClip.new()
local Label = script.Parent.ImageLabel

SpriteClipObject.InheritSpriteSheet = true
SpriteClipObject.Adornee = Label

--SpriteClipObject.SpriteSizePixel = Vector2.new(6400/4,1600)
SpriteClipObject.SpriteSizePixel = Vector2.new(90, 100)
SpriteClipObject.SpriteOffsetPixel = Vector2.new(93, 0)
SpriteClipObject.SpriteCountX = 11
SpriteClipObject.SpriteCount = 11

SpriteClipObject.Looped = true
SpriteClipObject.State = true

SpriteClipObject.FrameRate = 15
SpriteClipObject:Play()
--]]


local SpriteClip = require(script.SpriteClip)

local SpriteClipObject = SpriteClip.new()
local Label = script.Parent.Loading.ImageLabel

--We will make the SpriteClipObject take its Adornee's Image property.
--A custom image asset can be applied manually to the SpriteClip class itself through the SpriteSheet property.
SpriteClipObject.InheritSpriteSheet = true
SpriteClipObject.Adornee = Label
--It will be a file without an extension, so you will have to add .png to its end.
SpriteClipObject.SpriteSizePixel = Vector2.new(95/0,100)
SpriteClipObject.SpriteCountX = 11
SpriteClipObject.SpriteCount = 11

--The frame rate is set to 15 by default. It can range from 1 to 60, but the most important part is that it has to be a divisor of 60 (60%FR == 0).
--While setting a frame rate that isn't valid won't cause visible issues, it will clamp to the next higher valid value.
SpriteClipObject.FrameRate = 30

--Finally we can play our animation. You can also pause it and stop it with :Pause() and :Stop().
--Play will return true if the animation isn't playing, the reverse goes for pausing and stopping.
SpriteClipObject:Play()

--You can also manually increment the animation with the :Advance(FrameCount) method and set the current frame with the CurrentFrame property. Note that
--you'll have to run :Advance(0) after setting it.

