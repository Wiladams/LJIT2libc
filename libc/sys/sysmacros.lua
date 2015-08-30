local ffi = require("ffi")
local bit = require("bit")
local bor, band, lshift, rshift = bit.bor, bit.band, bit.lshift, bit.rshift
local utils = require("libc_utils")

-- TODO - create a test case to get this confirmed correctly
local function major(x) 
	--return  bor((((x)>>31>>1) & 0xfffff000), band(rshift((x),8), 0x00000fff)) ;
end

local function minor(x)
	return bor( band(rshift(x,12), 0xffffff00), band((x), 0x000000ff) );
end

local function makedev(x,y)
    return bor(lshift(band(x,0xfffff000ULL), 32), 
		lshift(band((x),0x00000fffULL), 8),
        lshift(band((y),0xffffff00ULL), 12), 
		(band((y),0x000000ffULL)))
end

local exports = {
	major = major;
	minor = minor;
	makedev = makedev;
}

return exports
