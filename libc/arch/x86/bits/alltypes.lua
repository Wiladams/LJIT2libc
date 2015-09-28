-- alltypes.lua

local ffi = require("ffi")
local utils = require("libc_utils")

--[[
TODO
These get used lexically to modify other types
so we can't just #define them


#define _Addr int
#define _Int64 long long
#define _Reg int

Typical usage:

typedef unsigned _Addr size_t;

Perhaps define them as strings and create a macro to deal with 
the concatenation.
--]]
ffi.cdef[[
typedef long long _Int64;
]]


ffi.cdef[[
typedef struct { long long __ll; long double __ld; } max_align_t;

typedef long time_t;
typedef long suseconds_t;
]]

