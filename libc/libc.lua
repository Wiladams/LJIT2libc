--libc.lua

local ffi = require("ffi")

local exports = {
	
}
setmetatable(exports, {
	__index = function(self, key)
		-- First, see if it's one of the functions in the library
		local success, value = pcall(function() return ffi.C[key] end)
		if success then
			rawset(key, value)
			return value;
		end

		-- next, see if it's one of the constants

		-- finally, return nil if it's nothing we can get to easily
		return nil;
	end,

})