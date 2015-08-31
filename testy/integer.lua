local init = require("test_setup")()
local ffi = require("ffi")

local a = ffi.new("int[1]");

printf("Enter an integer\n");
scanf("%d", a);

printf("Integer that you have entered is %d\n", a[0]);
--[=[
  ffi.cdef[[
  int sscanf(const char *str, const char *fmt, ...);
  ]]
--]=]
  local pn = ffi.new("int[1]")
  ffi.C.sscanf("foo 123", "foo %d", pn)
  print(pn[0])