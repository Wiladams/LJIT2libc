-- alltypes.lua

local ffi = require("ffi")
local utils = require("libc_utils")

--[[
TODO
These get used lexically to modify other types
so we can't just #define them

#define _Addr long
#define _Int64 long
#define _Reg long

Typical usage:

typedef unsigned _Addr size_t;

Perhaps define them as strings and create a macro to deal with 
the concatenation.
--]]
ffi.cdef[[
typedef long _Int64;
]]


ffi.cdef[[
typedef struct { long long __ll; long double __ld; } max_align_t;

typedef long time_t;
typedef long suseconds_t;
]]

