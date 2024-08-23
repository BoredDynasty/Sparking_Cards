--!strict
local HttpService = game:GetService("HttpService")

local URL_ASTROS = "http://api.open-notify.org/astros.json"

-- Make the request to our endpoint URL
local response = HttpService:GetAsync(URL_ASTROS)

-- Parse the JSON response
local data = HttpService:JSONDecode(response)

-- Information in the data table is dependent on the response JSON
if data.message == "success" then
	print("There are currently " .. data.number .. " astronauts in space:")
	for i, person in pairs(data.people) do
		print(i .. ": " .. person.name .. " is on " .. person.craft)
	end
end
