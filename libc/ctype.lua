--[[
	ctype.h

	Character classifiers and manipulators.  Althought there are
	implementations of these within libc, often times they are
	implemented as macros, or compiler intrinsics.

	Since they are all so small, it's probably better to just 
	reimplement them as lua code, and let the jit take care of 
	optimizing their usage.  Saves on bothering with function call
	overhead, which is likely to be more expensive than the actual
	code.
--]]
local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor;
local utils = require("libc_utils")

local byte = string.byte;


local function isalpha(c) return (bor(c,32)-byte'a') < 26 end
local function isblank(c) return (c == byte(' ') or c == byte('\t')); end
local function isdigit(a) return (a-byte'0') < 10 end
local function islower(a) return (a-byte'a') < 26 end
local function isupper(a) return (a-byte'A') < 26 end
local function isprint(a) return (a-0x20) < 0x5f end
local function isgraph(a) return (a-0x21) < 0x5e end
local function isspace(a) return a == byte(' ') or a-byte('\t') < 5; end
	
local function isascii(a) return a >=0 and a <=0x7f end
local function isalnum(c) return isalpha(c) or isdigit(c) end
local function iscntrl(c) return (c >= 0 and c < 0x20) or (c == 0x7f) end
local function ispunct(c) return isgraph(c) and not isalnum(c) end
local function isxdigit(c)
	if isdigit(c) then return true end

	return (c >= byte'a' and c <= byte'f') or
		(c >= byte'A' and c <= byte'F')
end

local function tolower(c) return band(0xff,bor(c, 0x20)) end
local function toupper(c)
	if (islower(c)) then
		return band(c, 0x5f)
	end

	return c
end


local exports = {
	isalnum = isalnum;
	isalpha = isalpha;
	isascii = isascii;
	isblank = isblank;
	iscntrl = iscntrl;
	isdigit = isdigit;
	isgraph = isgraph;
	islower = islower;
	isprint = isprint;
	ispunct = ispunct;
	isspace = isspace;
	isupper = isupper;
	isxdigit = isxdigit;
	tolower = tolower;
	toupper = toupper;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(exports, tbl)

		return self
	end,
})

return exports
