local init = require("test_setup")()
local ffi = require("ffi")

local int = ffi.typeof("int")
local int_a = ffi.typeof("int[?]")

--local a = ffi.new("int[1]");
local a = int_a(1);

printf("Enter integer\n");
scanf("%d", a);

printf("Integer that you have entered is %d\n", int(a[0]));
