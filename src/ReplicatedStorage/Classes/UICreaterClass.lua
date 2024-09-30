--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local UIEffectsClass = require(ReplicatedStorage.Classes:WaitForChild("UIEffectsClass"))

--- @class UICreatorClass
--- @__index UICreatorClass
---
--- This Class allows for Creating UI packed inside a module.
local Class = {}
Class.__index = Class

export type __index = {
	self: table,
}

local self

-- The Dubious Dynasty

--[=[
	Constructor
--]=]
function Class.Constructor(): __index
	self = setmetatable({}, Class)

	self.baseFrameSize = UDim2.new(0, 450, 0, 600)
	self.baseTitleSize = UDim2.new(0, 225, 0, 200)
	self.baseTitlePosition = UDim2.new(0.5, 0, -0.8, 0)

	self.createBaseElements = function(backgroundColor, visible)
		if not backgroundColor then
			backgroundColor = UIEffectsClass.getColor("White")
			local ScreenGui = Instance.new("ScreenGui")
			local Frame = Instance.new("Frame", ScreenGui)
			Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame.Position = UDim2.new(0, 0.5, 0, 0.5)
			Frame.Size = self.baseFrameSize
			Frame.BackgroundColor3 = backgroundColor
			Frame.Visible = visible

			local UICorner = Instance.new("UICorner", Frame)
			UICorner.CornerRadius = UDim.new(0.2, 0)
			return ScreenGui, Frame
		end

		self.createTextLabel = function(title, textColor, position)
			local descriptionElement = Instance.new("TextLabel")
			descriptionElement.AnchorPoint = Vector2.new(0.5, 0.5)
			descriptionElement.Parent = script.Parent
			descriptionElement.Text = title
			descriptionElement.Size = self.baseTitleSize
			descriptionElement.Position = position or self.baseTitlePosition
			descriptionElement.TextColor3 = UIEffectsClass.getColor(tostring(textColor))
			descriptionElement.BackgroundTransparency = 1
			descriptionElement.BorderSizePixel = 0

			return descriptionElement
		end

		return self
	end
end

--[=[
	Create a Basic Frame Element

	@param backgroundColor -- The Background Color you want the frame to have
	@field actions -- A table of buttons
	@field actionsToBind -- The functions that happens when a player interacts with an action.
	@param title -- The Frame Title
	@param description -- The Description
	@param description -- Another Description
	@param visible -- The visibility of the frame
	@return any
--]=]
function Class.CreateFrameElement(
	backgroundColor,
	actions: any,
	actionsToBind: any,
	title,
	description,
	description2,
	visible
): any
	local baseElements = self.createBaseElements(backgroundColor, visible)
	local titleElement = self.createTextLabel(title, "White")
	local description1Element = self.createTextLabel()
	titleElement.Parent = baseElements[2]
	if description2 then
		local description2Element = self.createTextLabel(description2)
	end

	return baseElements
end

return Class
