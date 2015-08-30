local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor;
local band = bit.band;
local lshift = bit.lshift;
local rshift = bit.rshift;

local utils = require("libc_utils")

--[[
	These macros need to be confirmed for correctness and speed.
	It's more likely ffi.bswap can cover all these cases one 
	way or another.
--]]
local function bswap_16(__x)
	return bor(lshift(__x, 8), rshift(__x, 8));
end

local function bswap_32(__x)
	return bor(rshift(__x,24), band(rshift(__x,8),0xff00), band(lshift(__x,8),0xff0000), lshift(__x,24));
end

local function bswap_64(__x)
	return bor((__bswap_32(__x)+lsfhit(0ULL,32)), bswap_32(rshift(__x,32)));
end

local exports = {
	bswap_16 = bswap_16;
	bswap_32 = bswap_32;
	bswap_64 = bswap_64;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(exports, tbl)

		return self
	end,
})

return exports
