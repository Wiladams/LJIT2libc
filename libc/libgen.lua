local ffi = require("ffi")

ffi.cdef[[
char *dirname(char *);
char *basename(char *);
]]

local exports = {
	dirname = ffi.C.dirname;
	basename = ffi.C.basename;	
}

return exports 