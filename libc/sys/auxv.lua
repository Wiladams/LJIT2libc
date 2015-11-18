local ffi = require("ffi")

require ("elf")

ffi.cdef[[
unsigned long getauxval(unsigned long);
]]
