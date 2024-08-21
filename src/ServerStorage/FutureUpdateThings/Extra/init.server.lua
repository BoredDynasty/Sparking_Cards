print("Extra")
print("Hello World! .lua")
print("This place doesn't have streaming enabled.")

local ExtraScripts = script:GetDescendants()

local scripts = {} 

local ReturnExtraScripts = function()
	return ExtraScripts
end

ReturnExtraScripts()