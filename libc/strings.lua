local ffi = require("ffi")

require("bits/alltypes")

ffi.cdef[[
void bcopy (const void *, void *, size_t);
void bzero (void *, size_t);
char *index (const char *, int);
char *rindex (const char *, int);
]]

ffi.cdef[[
int ffs (int);
int ffsl (long);
int ffsll (long long);
]]

ffi.cdef[[
int strcasecmp (const char *, const char *);
int strncasecmp (const char *, const char *, size_t);

//int strcasecmp_l (const char *, const char *, locale_t);
//int strncasecmp_l (const char *, const char *, size_t, locale_t);
]]

local exports = {
	bcopy = ffi.C.bcopy;
	bzero = ffi.C.bzero;
	index = ffi.C.index;
	rindex = ffi.C.rindex;
}

return exports