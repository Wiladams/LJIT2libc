--[[
	Note: Do NOT require this file directly.  It fills in the 
	arch specific gaps of the /stdint.lua file, and is included
	from there, after various standard definitions are already 
	in place (like INT32_MIN).
--]]

local ffi = require("ffi")


ffi.cdef[[
typedef int32_t int_fast16_t;
typedef int32_t int_fast32_t;
typedef uint32_t uint_fast16_t;
typedef uint32_t uint_fast32_t;
]]



local function setup(base)
	local exports = {
		INT_FAST16_MIN  =base.INT32_MIN;
		INT_FAST32_MIN  =base.INT32_MIN;

		INT_FAST16_MAX  =base.INT32_MAX;
		INT_FAST32_MAX  =base.INT32_MAX;

		UINT_FAST16_MAX =base.UINT32_MAX;
		UINT_FAST32_MAX =base.UINT32_MAX;

		INTPTR_MIN      =base.INT64_MIN;
		INTPTR_MAX      =base.INT64_MAX;
		UINTPTR_MAX     =base.UINT64_MAX;
		PTRDIFF_MIN     =base.INT64_MIN;
		PTRDIFF_MAX     =base.INT64_MAX;
		SIZE_MAX        =base.UINT64_MAX;
	}

	return exports
end

return setup

