

local ffi = require("ffi")

local function parentPath()
ffi.cdef[[
char *getcwd(char *, size_t);
]]

	local buffsize = 256;
	local buff = ffi.new("char[?]", buffsize)
	local current_dir=ffi.string(ffi.C.getcwd(buff, buffsize));

	return current_dir:match("(.+)%/[^%/]%/[^%/]+$")
end

local function homePath()
	local hPath=  parentPath().."../libc";

	print("HOME PATH: ", hPath)

	return hPath;
end


local function setup()
	-- we have to set the package path here so that we can
	-- at least do a require('init')
	package.path = package.path..";"..homePath().."/?.lua"

--print("hello.package.path: ", package.path)

	return require("init")(homePath())
end

return setup()
