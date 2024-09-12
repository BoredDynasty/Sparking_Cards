--!strict
local Class = {} -- Math Simplified
Class.__index = Class
Class.Library = math

function Class.Radius(x) -- Returns Radi
	return Class.Library.rad(x)
end

function Class.Sine(radians) -- Makes a sine wave in Radians
	return Class.Library.sin(radians)
end

function Class.Lerp(a, b, t) -- Returns a Lerp
	return a + (b - a) * t
end

function Class.Random(m, n) -- Returns a random number
	return Class.Library.random(m, n)
end

function Class.Infinite() -- Returns an infinite number (2 `1024` )
	return tonumber(Class.Library.huge)
end

function Class.RoundDown(x) -- Rounds Down
	return Class.Library.floor(x)
end

function Class.RoundUp(x) -- Rounds Up
	return Class.Library.ceil(x)
end

function Class.Noise(x, y, z) -- Returns Perlin noise
	return math.noise(x, y, z)
end

function Class.pi(full: boolean) -- Returns the full version of "pi", if you don't want the full version of "pi" then it will return a very truncated version.
	if full == true then
		return Class.Library.abs(tonumber(Class.Library.pi))
	else
		return 3.14
	end
end

function Class.ArcSine(x) -- Returns an Arc Sine
	return Class.Library.asin(x)
end

function Class.Absolute(x) -- Returns an ABSOLUTE value
	return Class.Library.abs(x)
end

function Class.Vector3One()
	return Vector3.one
end

function Class.Vector3(X, Y, Z)
	return Vector3.new(X, Y, Z)
end

return Class
