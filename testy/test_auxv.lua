-- test_syscall.lua
-- References
--	ld-linux.so
--  getauxval
local init = require("test_setup")()
local ffi = require("ffi")
local Sys = require("syscalls")
local libc = require("libc")

local function getStringAuxVal(atype)
	local res = libc.getauxval(atype)

	if res == 0 then 
		return false, "type not found"
	end

	local str = ffi.string(ffi.cast("char *", res));
	return str
end

local function getExecPath()
	return getStringAuxVal(libc.AT_EXECFN);
end

local function getPlatform()
	return getStringAuxVal(libc.AT_PLATFORM);
end

local function getPageSize()
	local res = libc.getauxval(libc.AT_PLATFORM)

	if res == 0 then 
		return false, "type not found"
	end

	return ffi.cast("unsigned long *",res)[0]
end

print(" Platform: ", getPlatform());
print("Exec Path: ", getExecPath());
print("Page Size: ", getPageSize());

