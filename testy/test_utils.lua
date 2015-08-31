

local ffi = require("ffi")

local function parentPath()
ffi.cdef[[
char *getcwd(char *, size_t);
]]

	local buffsize = 256;
	local buff = ffi.new("char[?]", buffsize)
	local current_dir=ffi.string(ffi.C.getcwd(buff, buffsize));

	return current_dir:match("(.+)%/[^%/]+$")
end

local exports = {
	LibPath = parentPath().."/libc"
}

return exports
