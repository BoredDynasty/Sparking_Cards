

local swagtext = {}

local RNS = game:GetService("RunService")
local SG = game:GetService("StarterGui")
local TS = game:GetService("TweenService")

local function CheckForListLayout(target, verbose)
	for _, d in pairs(target:GetChildren()) do
		if d:IsA("UIListLayout") then
			return true
		elseif d:IsA("UIGridLayout") then
			if verbose then warn("SWAGTEXT >> ", target, "contains UIGridLayout. This may cause issues with word formatting.") end
			return true
		end
	end
	if verbose then warn("SWAGTEXT >> ", target, "does not contain UIListLayout or UIGridLayout. One will be created.") end
	return false
end

local function ShakeTest(target)
	while true do
		wait(0.05)
		local x, y, r = math.random(0, 0), math.random(-2, 2), math.random(-10, 10)
		target.Position = UDim2.new(0, x, 0, y)
		target.Rotation = r
	end
end

local function Warp(target)
	while true do
		TS:Create(target, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.fromOffset(0, 2)}):Play()
		wait(0.5)
		TS:Create(target, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.fromOffset(0, -2)}):Play()
		wait(0.5)
	end
end

local function TextAppear(target, mode)	
	if mode then
		if string.match(mode, "fade") then
			target.TextTransparency = 1
			TS:Create(target, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		end

		if string.match(mode, "up") then
			target.Position = UDim2.fromOffset(0, 5)
			TS:Create(target, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)}):Play()
		elseif string.match(mode, "down") then
			target.Position = UDim2.fromOffset(0, -5)
			TS:Create(target, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)}):Play()
		elseif string.match(mode, "diverge") then
			target.Position = UDim2.fromOffset(0, math.random(-5, 5))
			TS:Create(target, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)}):Play()
		end

		if string.match(mode, "rotate") then
			target.Rotation = 30
			TS:Create(target, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
		elseif string.match(mode, "rotright") then
			target.Rotation = -30
			TS:Create(target, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
		elseif string.match(mode, "shake") then
			local rand = math.random(-30, 30)
			target.Rotation = rand
			TS:Create(target, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Rotation = 0}):Play()
		elseif string.match(mode, "rotultra") then
			target.Rotation = 360
			TS:Create(target, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
		end
	end
end

local function RainbowText(target, offset)
	RNS:BindToRenderStep("rainbow", 1000, function()
		local hue = ((tick() % 3 / 3) + ((offset * 2) / 255)) % 255
		while hue > 1 do hue -= 1 end
		local color = Color3.fromHSV(hue, 1, 1)
		target.TextColor3 = color
	end)
end

str = ""
local state = {}
local default = {color = Color3.new(1, 1, 1), bold = false, italic = false, rainbow = false, shake = false, warp = false, waitTime = -1}
table.insert(state, default)

local commands = {
	["<red>"] = function() return {color = Color3.new(1, 0, 0), bold = state[#state].bold, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<blue>"] = function() return {color = Color3.new(0, 0, 1), bold = state[#state].bold, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<bold>"] = function() return {color = state[#state].color, bold = true, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<italic>"] = function() return {color = state[#state].color, bold = state[#state].bold, italic = true, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<rainbow>"] = function() return {color = state[#state].color, bold = state[#state].bold, italic = state[#state].italic, rainbow = true, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<shake>"] = function() return {color = state[#state].color, bold = state[#state].bold, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = true, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<warp>"] = function() return {color = state[#state].color, bold = state[#state].bold, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = true, waitTime = state[#state].waitTime} end,
	["<color=#"] = function() return {color = Color3.new(1, 1, 1), bold = state[#state].bold, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime} end,
	["<pause="] = function() return {color = state[#state].color, bold = state[#state].bold, italic = state[#state].italic, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = 0} end,
	["</"] = function() table.remove(state) end, -- pop the current state
}

local word = {}
local wordLocation = nil

function swagtext.AnimateText(str, location, delayTime, font, mode, wordMode, textSize, ahori, avert, extra, verbose)
	
	print("location -- ", location:GetFullName())
	if not CheckForListLayout(location, verbose) then
		local layout = script.Assets.FrameListLayout:Clone()
		layout.Parent = location
		if ahori then layout.HorizontalAlignment = ahori end
		if avert then layout.VerticalAlignment = avert	end	
	end
	
	local i = 1
	while i <= string.len(str) do
		local letter = string.sub(str, i, i)
		print(letter)
		
		if wordMode == 1 or wordMode == nil then
			if #word == 0 then
				local wordframe = Instance.new("Frame")
				wordframe.AutomaticSize = Enum.AutomaticSize.XY
				wordframe.Size = UDim2.new(0, 0, 0, 1)
				wordframe.Parent = location
				wordLocation = wordframe
				wordframe.BackgroundTransparency = 1
				wordframe.Name = "SWAGTEXT_WORDFRAME"
				local listlayout = Instance.new("UIListLayout")
				listlayout.Parent = wordframe
				listlayout.FillDirection = Enum.FillDirection.Horizontal
			end

			if letter == " " then
				table.clear(word)
			else
				table.insert(word, letter)
			end
		end
		
		if letter == "<" then
			for command, action in pairs(commands) do
				if string.sub(str, i, i + #command - 1) == command then
					if command == "</" then
						action()
						i = i + (string.find(str, ">", i) or 0) - i + 1 
					elseif command == "<color=#" then -- custom way of handling the color command because it requires an input
						local hex = string.sub(str, i+8, i+13)
						local new = {color = Color3.fromHex(hex), bold = state[#state].bold, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = state[#state].waitTime}
						table.insert(state, new)
						i = i + (string.find(str, ">", i) or 0) - i + 1
					elseif command == "<pause=" then
						local length = string.find(str, ">", i)
						local input = tonumber(string.sub(str, i + 7, length - 1))
						if input then
							-- Create a new state with the updated waitTime
							local new = {color = state[#state].color, bold = state[#state].bold, rainbow = state[#state].rainbow, shake = state[#state].shake, warp = state[#state].warp, waitTime = input}
							-- Insert the new state at the beginning (overrides current waitTime)
							table.insert(state, new)
							print(state[#state].waitTime)  -- Verify successful update
						else
							warn("SWAGTEXT >> Invalid pause time provided in <pause= command.")
						end
						i = i + (string.find(str, ">", i) or 0) - i + 1
					else
						local new = action()
						table.insert(state, new)
						i = i + #command -- skip past the tag
					end
					break
				end
			end
		else
			
			local char = script.Assets.LetterFrame:Clone()
			
			if wordMode == 1 or wordMode == nil then
				char.Parent = wordLocation
			else
				char.Parent = location
			end

			char.TextLabel.Text = letter
			local current = state[#state] or default
			
			if font then
				char.TextLabel.Font = font
			else
				char.TextLabel.Font = Enum.Font.Arial
			end
			
			if current.shake then
				coroutine.wrap(ShakeTest)(char.TextLabel)
			elseif current.warp then
				coroutine.wrap(Warp)(char.TextLabel)
			end

			if current.rainbow then
				RainbowText(char.TextLabel, (i * 5))
			else
				char.TextLabel.TextColor3 = current.color or default.color
			end

			if current.bold then
				char.TextLabel.RichText = true
				char.TextLabel.Text = "<b>"..letter.."</b>"
			end
			
			if current.italic then
				char.TextLabel.RichText = true
				char.TextLabel.Text = "<i>"..letter.."</i>"
			end
			
			if textSize then
				char.TextLabel.TextScaled = false
				char.TextLabel.TextSize = textSize
				char.AutomaticSize = Enum.AutomaticSize.XY
			end
			
			if typeof(extra) == "table" then
				for i, v in extra do
					print(v)
					v:Clone().Parent = char.TextLabel
				end
			elseif extra then
				print(extra)
				extra:Clone().Parent = char.TextLabel
			end
			
			TextAppear(char.TextLabel, mode)
			char.Name = "SWAGTEXT_LETTERFRAME"
			char.Visible = true
			i = i + 1
		end
		
		--print(letter, delayTime, s.waitTime)
		if state[#state].waitTime >= 0 then
			wait(state[#state].waitTime)
		else
			wait(delayTime or 0.05)
		end
	end
end

function swagtext.ClearText(location)
	if location then
		for _, l in location:GetChildren() do
			if l.Name == "SWAGTEXT_WORDFRAME" or l.Name == "SWAGTEST_LETTERFRAME" then
				l:Destroy()
			end
		end
	else
		warn("SWAGTEXT >> Cannot clear text because the location was invalid")	
	end
end

return swagtext