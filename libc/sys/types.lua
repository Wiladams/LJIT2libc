--[[
	This file is probably the hardest to get right.  These core typedefs might change
	depending on the platform/library of the libc.  

	Note: 
		The definitions are encapsulated in an OS specific code block.  If the 
		OS of the current platform doesn't match an existing block, then everything
		else in the library will fail, requiring a new block to be considered.

		This is desirable because it prevents spurious errors from occuring due to
		fundamental type mismatches.
--]]

local ffi = require("ffi")
local utils = require("libc_utils")


if ffi.os == "Linux" then
ffi.cdef[[
typedef long ssize_t;

typedef long time_t;
typedef long suseconds_t;



struct timeval { time_t tv_sec; suseconds_t tv_usec; };
struct timespec { time_t tv_sec; long tv_nsec; };

typedef uint64_t dev_t;
typedef uint32_t mode_t;

// networking
typedef unsigned short sa_family_t;
typedef unsigned int socklen_t;

]]
end

local Types = {
	timeval = ffi.typeof("struct timeval");
	timespec = ffi.typeof("struct timespec");	
}

local exports = {
	Types = Types;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Types, tbl);

		return self
	end,
})

return exports
