
local ffi = require("ffi")

require("bits/alltypes")

ffi.cdef[[
void *memcpy (void *__restrict, const void *__restrict, size_t);
void *memmove (void *, const void *, size_t);
void *memset (void *, int, size_t);
int memcmp (const void *, const void *, size_t);
void *memchr (const void *, int, size_t);

char *strcpy (char *__restrict, const char *__restrict);
char *strncpy (char *__restrict, const char *__restrict, size_t);

char *strcat (char *__restrict, const char *__restrict);
char *strncat (char *__restrict, const char *__restrict, size_t);

int strcmp (const char *, const char *);
int strncmp (const char *, const char *, size_t);

int strcoll (const char *, const char *);
size_t strxfrm (char *__restrict, const char *__restrict, size_t);

char *strchr (const char *, int);
char *strrchr (const char *, int);

size_t strcspn (const char *, const char *);
size_t strspn (const char *, const char *);
char *strpbrk (const char *, const char *);
char *strstr (const char *, const char *);
char *strtok (char *__restrict, const char *__restrict);

size_t strlen (const char *);

char *strerror (int);
]]

local strings_h = require("strings")


ffi.cdef[[
char *strtok_r (char *__restrict, const char *__restrict, char **__restrict);
int strerror_r (int, char *, size_t);
char *stpcpy(char *__restrict, const char *__restrict);
char *stpncpy(char *__restrict, const char *__restrict, size_t);
size_t strnlen (const char *, size_t);
char *strdup (const char *);
char *strndup (const char *, size_t);
char *strsignal(int);
//char *strerror_l (int, locale_t);
//int strcoll_l (const char *, const char *, locale_t);
//size_t strxfrm_l (char *__restrict, const char *__restrict, size_t, locale_t);
]]

ffi.cdef[[
void *memccpy (void *__restrict, const void *__restrict, int, size_t);
]]

ffi.cdef[[
char *strsep(char **, const char *);
size_t strlcat (char *, const char *, size_t);
size_t strlcpy (char *, const char *, size_t);
]]

ffi.cdef[[
int strverscmp (const char *, const char *);
//int strcasecmp_l (const char *, const char *, locale_t);
//int strncasecmp_l (const char *, const char *, size_t, locale_t);
char *strchrnul(const char *, int);
char *strcasestr(const char *, const char *);
void *memmem(const void *, size_t, const void *, size_t);
void *memrchr(const void *, int, size_t);
void *mempcpy(void *, const void *, size_t);
char *basename();
]]

--#define	strdupa(x)	strcpy(alloca(strlen(x)+1),x)
local function stringerror(num)
	num = num or ffi.errno();
	local str = ffi.C.strerror(num)
	if str == nil then
		return string.format("ERROR:[%d]", num)
	end

	return ffi.string(str);
end

local exports = {
	memchr = ffi.C.memchr;
	memcmp = ffi.C.memcmp;
	memcpy = ffi.C.memcpy;
	memmove = ffi.C.memmove;
	memset = ffi.C.memset;

	strlen = ffi.C.strlen;
	strerror = ffi.C.strerror;
	errno_string = stringerror;
}

setmetatable(exports, {
	__call = function(self, tbl)
		tbl = tbl or _G
		for k,v in pairs(self) do
			tbl[k] = v;
		end
		return self;
	end,
})

return exports
