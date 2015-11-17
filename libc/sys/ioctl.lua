local ffi = require("ffi")

local bits_ioctl = require("bits/ioctl")

ffi.cdef[[
int ioctl (int, int, ...);
]]


local exports = {
	ioctl = ffi.C.ioctl;	
}

setmetatable(exports, {
	__call = function(self, tbl)
		tbl = tbl or _G;
		for k,v in pairs(self) do
			tbl[k] = v;
		end

		return self;
	end,
})

return exports