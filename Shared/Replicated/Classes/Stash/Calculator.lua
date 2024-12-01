return function(inst: Instance)
	local attributes = inst:GetAttributes()
	local finalValue
	if type(attributes) == "number" then
		for _, value in attributes do
			finalValue = finalValue + value
		end
	end
	return finalValue
end
