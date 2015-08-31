local ffi = require("ffi")

ffi.cdef[[
int printf(const char *__restrict, ...);
int scanf(const char *__restrict, ...);
int sscanf(const char *__restrict, const char *__restrict, ...);
]]
local int = ffi.typeof("int")

local a = ffi.new("int[1]");  		-- This one prints '0' as the value
local a64 = ffi.new("int64_t[1]");	-- This one works for a 64-bit build
ffi.C.printf("Enter an integer\n");
ffi.C.scanf("%d", a);
ffi.C.printf("Integer that you have entered is %d\n", int(a[0]));

print("type: a: ",type(a), type(a[0]))
print("type a64: ", type(a64), type(a64[0]))