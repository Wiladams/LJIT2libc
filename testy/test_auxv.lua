-- test_syscall.lua
-- References
--	ld-linux.so
--  getauxval
local init = require("test_setup")()
local ffi = require("ffi")
local Sys = require("syscalls")
local libc = require("libc")



local function auxvaluefortype(atype, value)
	if atype == libc.AT_EXECFN or atype == libc.AT_PLATFORM then
		return ffi.string(ffi.cast("char *", value))
	end

	if atype == libc.AT_UID or atype == libc.AT_EUID or
		atype == libc.AT_GID or atype == libc.AT_EGID or 
		atype == libc.AT_FLAGS or atype == libc.AT_PAGESZ or
		atype == libc.AT_HWCAP or atype == libc.AT_CLKTCK or 
		atype == libc.AT_PHENT or atype == libc.AT_PHNUM then

		return tonumber(value)
	end

	if atype == libc.AT_SECURE then
		if value == 0 then 
			return false
		else
			return true;
		end
	end


	return value;
end



local function getStringAuxVal(atype)
	local res = libc.getauxval(atype)

	if res == 0 then 
		return false, "type not found"
	end

	local str = ffi.string(ffi.cast("char *", res));
	return str
end

local function getIntAuxValue(atype)
	local res = libc.getauxval(atype)

	if res == 0 then 
		return false, "type not found"
	end

	return tonumber(res);
end

local function getPtrAuxValue(atype)
	local res = libc.getauxval(atype)

	if res == 0 then 
		return false, "type not found"
	end

	return ffi.cast("intptr_t", res);
end


-- convenience functions
local function getExecPath()
	return getStringAuxVal(libc.AT_EXECFN);
end

local function getPlatform()
	return getStringAuxVal(libc.AT_PLATFORM);
end

local function getPageSize()
	return getIntAuxValue(libc.AT_PAGESZ);
end

local function getRandom()
	return getPtrAuxValue(libc.AT_RANDOM);
end

--[[
	Some test cases
--]]
local function test_getauxvalue()
print(" Platform: ", getPlatform());
print("Exec Path: ", getExecPath());
print("Page Size: ", getPageSize());
print("   Random: ", getRandom());
end

test_getauxvalue();
