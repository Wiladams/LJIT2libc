-- test_syscall.lua
-- References
--	ld-linux.so
--  getauxval
local init = require("test_setup")()
local ffi = require("ffi")
local Sys = require("syscalls")
local libc = require("libc")

local auxtbl = {
	[0] =  "AT_NULL";
	[1] =  "AT_IGNORE";
	[2] = "AT_EXECFD";
	[3] = "AT_PHDR";
	[4] = "AT_PHENT";
	[5] = "AT_PHNUM";
	[6] = "AT_PAGESZ";
	[7] = "AT_BASE";
	[8] = "AT_FLAGS";
	[9] = "AT_ENTRY";
[10] = "AT_NOTELF";
[11] = "AT_UID";
[12] = "AT_EUID";
[13] = "AT_GID";
[14] = "AT_EGID";
[17] = "AT_CLKTCK";
[15] = "AT_PLATFORM";
[16] = "AT_HWCAP";
[18] = "AT_FPUCW";
[19] = "AT_DCACHEBSIZE";
[20] = "AT_ICACHEBSIZE";
[21] = "AT_UCACHEBSIZE";
[22] = "AT_IGNOREPPC";
[23] = "AT_SECURE";
[24] = "AT_BASE_PLATFORM";
[25] = "AT_RANDOM";
[26] = "AT_HWCAP2";
[31] = "AT_EXECFN";
[32] = "AT_SYSINFO";
[33] = "AT_SYSINFO_EHDR";
[34] = "AT_L1I_CACHESHAPE";
[35] = "AT_L1D_CACHESHAPE";
[36] = "AT_L2_CACHESHAPE";
}

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

local function auxviterator(path)
	path = path or "/proc/self/auxv"
	local fd = libc.open(path, libc.O_RDONLY);

	local params = {
		fd = fd;
		keybuff = ffi.new("intptr_t[1]");
		valuebuff = ffi.new("intptr_t[1]");
		buffsize = ffi.sizeof(ffi.typeof("intptr_t"));
	}


	local function gen_value(param, state)
		local res1 = libc.read(param.fd, param.keybuff, param.buffsize)
		local res2 = libc.read(param.fd, param.valuebuff, param.buffsize)
		if param.keybuff[0] == 0 then
			libc.close(param.fd);
			return nil;
		end

		local atype = tonumber(param.keybuff[0])
		return atype, auxvaluefortype(atype, param.valuebuff[0])
	end

	return gen_value, params, 0

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

local function test_auxviter()
	--for key, value in auxviterator() do
	for key, value in auxviterator("/proc/2424/auxv") do
		io.write(string.format("%20s[%2d] : ", auxtbl[key], key))
		print(value);
	end
end


--test_getauxvalue();
test_auxviter();

