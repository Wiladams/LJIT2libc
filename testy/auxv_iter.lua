-- auxv_iter.lua

-- An iterator over the auxv values of a process
-- Assuming 'libc' is already somewhere on the path
-- References
--	ld-linux.so
--  getauxval

local ffi = require("ffi")
local libc = require("libc")

local E = {}

-- This table maps the constant values for the various
-- AT_* types to their symbolic names.  This table is used
-- to both generate cdefs, as well and hand back symbolic names
-- for the keys.
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

-- Given a auxv key(type), and the value returned from reading
-- the file, turn the value into a lua specific type.
-- string pointers --> string
-- int values -> number
-- pointer values -> intptr_t

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


	return ffi.cast("intptr_t", value);
end

-- iterate over the auxv values at the specified path
-- if no path is specified, use '/proc/self/auxv' to get
-- the values for the currently running program
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
		return state, atype, auxvaluefortype(atype, param.valuebuff[0])
	end

	return gen_value, params, 0

end

-- generate ffi.cdef calls to turn the symbolic type names
-- into constant integer values
local cdefsGenerated = false;

local function gencdefs()
	for k,v in pairs(auxtbl) do		
		-- since we don't know if this is already defined, we wrap
		-- it in a pcall to catch the error
		pcall(function() ffi.cdef(string.format("static const int %s = %d;", v,k)) end)
	end
	cdefsGenerated = true;
end

-- get a single value for specified key.  A path can be specified
-- as well (default it '/proc/self/auxv')
-- this is most like the gnuC getauxval() function
local function getOne(key, path)
	-- iterate over the values, looking for the one we want
	for _, atype, value in auxviterator(path) do
		if atype == key then
			return value;
		end
	end

	return nil;
end

E.gencdefs = gencdefs;
E.keyvaluepairs = auxviterator;	
E.keynames = auxtbl;
E.getOne = getOne;

setmetatable(E, {
	-- we allow the user to specify one of the symbolic constants
	-- when doing a 'getOne()'.  This indexing allows for the creation
	-- and use of those constants if they haven't already been specified
	__index = function(self, key)
		if not cdefsGenerated then
			gencdefs();
		end

		local success, value = pcall(function() return ffi.C[key] end)
		if success then
			rawset(self, key, value);
			return value;
		end

		return nil;
	end,

})

return E
