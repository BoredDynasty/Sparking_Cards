--[[
    Scripter: Nyxaris
    Version: 1.0.3
]]

local DataManager = {}

--// Format a number with an abbreviation
function DataManager.FormatNumberWithAbbreviation(number)
	local success, formattedString = pcall(function()
		local suffixes = {"", "K", "M", "B", "T"}
		local suffixIndex = 1
		local formattedNumber = number

		while formattedNumber >= 1000 and suffixIndex < #suffixes do
			formattedNumber = formattedNumber / 1000
			suffixIndex = suffixIndex + 1
		end

		local showDecimal = formattedNumber ~= math.floor(formattedNumber)
		
		local formattedString
		if showDecimal then
			formattedString = string.format("%.1f", formattedNumber)
			formattedString = string.gsub(formattedString, "%.", ",")
		else
			formattedString = string.format("%.0f", formattedNumber)
		end

		return formattedString .. suffixes[suffixIndex]
	end)

	if not success then
		warn("[FNWA:DataManager] Error when formatting a number:", formattedString)
		return nil
	end

	return formattedString
end

--// Shorten text if necessary
function DataManager.ShortenTextIfNecessary(text, maxLength)
	maxLength = maxLength or 9
	local success, shortenedText = pcall(function()
		if type(text) == "string" and #text > maxLength then
			return string.sub(text, 1, maxLength - 3) .. "..."
		else
			return text
		end
	end)

	if not success then
		warn("[STIN:DataManager] Error when cropping text:", shortenedText)
		return nil
	end

	return shortenedText
end

--// Shorten team name if necessary
function DataManager.ShortenTextTeamName(text, maxLength)
	maxLength = maxLength or 28
	local success, shortenedTeamName = pcall(function()
		if type(text) == "string" and #text > maxLength then
			return string.sub(text, 1, maxLength - 3) .. "..."
		else
			return text
		end
	end)

	if not success then
		warn("[STTN:DataManager] Error when cropping text:", shortenedTeamName)
		return nil
	end

	return shortenedTeamName
end

--// Check if a string is numeric
function DataManager.IsStringNumeric(str)
	return tonumber(str) ~= nil
end

--// Format the value
function DataManager.FormatValue(value)
	local success, formattedValue = pcall(function()
		if DataManager.IsStringNumeric(value) then
			return DataManager.FormatNumberWithAbbreviation(tonumber(value))
		else
			return DataManager.ShortenTextIfNecessary(value)
		end
	end)

	if not success then
		warn("[FV:DataManager] Error formatting the value:", formattedValue)
		return nil
	end

	return formattedValue
end

return DataManager
