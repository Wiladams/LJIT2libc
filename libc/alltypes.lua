--alltypes.lua
local ffi = require("ffi")

--[[
ffi.cdef[[
TYPEDEF unsigned _Addr size_t;
TYPEDEF unsigned _Addr uintptr_t;
TYPEDEF _Addr ptrdiff_t;
TYPEDEF _Addr ssize_t;
TYPEDEF _Addr intptr_t;
TYPEDEF _Addr regoff_t;
TYPEDEF _Reg register_t;
]]
--]]