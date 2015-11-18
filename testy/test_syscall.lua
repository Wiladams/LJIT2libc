-- test_syscall.lua
local init = require("test_setup")()
local ffi = require("ffi")
local Sys = require("syscalls")



local buf = ffi.new("char [32]");
local buflen = 32;

local GRND_NONBLOCK	= 0x0001;
local GRND_RANDOM	= 0x0002;

print("getrandom: ", Sys.getrandom(buf, buflen, GRND_RANDOM));

