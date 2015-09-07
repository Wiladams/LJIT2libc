
local ffi = require("ffi")
local utils = require("libc_utils")

--#include <features.h>

require("bits/alltypes")

ffi.cdef[[
	typedef off_t off64_t;
	typedef ino_t ino64_t;
]]

ffi.cdef[[
typedef struct __dirstream DIR;

struct dirent
{
	ino_t d_ino;
	off_t d_off;
	unsigned short d_reclen;
	unsigned char d_type;
	char d_name[256];
};
]]

--#define d_fileno d_ino

ffi.cdef[[
int            closedir(DIR *);
DIR           *fdopendir(int);
DIR           *opendir(const char *);
struct dirent *readdir(DIR *);
int            readdir_r(DIR *__restrict, struct dirent *__restrict, struct dirent **__restrict);
void           rewinddir(DIR *);
void           seekdir(DIR *, long);
long           telldir(DIR *);
int            dirfd(DIR *);

int alphasort(const struct dirent **, const struct dirent **);
int scandir(const char *, struct dirent ***, int (*)(const struct dirent *), int (*)(const struct dirent **, const struct dirent **));

int getdents(int, struct dirent *, size_t);

int versionsort(const struct dirent **, const struct dirent **);

]]


local Constants = {
	DT_UNKNOWN = 0;
	DT_FIFO = 1;
	DT_CHR = 2;
	DT_DIR = 4;
	DT_BLK = 6;
	DT_REG = 8;
	DT_LNK = 10;
	DT_SOCK = 12;
	DT_WHT = 14;
}

local function IFTODT(x) return band(rshift(x,12), 017) end;
local function DTTOIF(x) return lshift(x,12) end;


local Functions = {
	-- local functions
	IFTODT = IFTODT;
	DTTOIF = DTTOIF;

	-- library functions
	closedir = ffi.C.closedir;
	fdopendir = ffi.C.fdopendir;
	opendir = ffi.C.opendir;
	readdir = ffi.C.readdir;
	readdir_r = ffi.C.readdir_r;
	rewinddir = ffi.C.rewinddir;
	seekdir = ffi.C.seekdir;
	telldir = ffi.C.telldir;
	dirfd = ffi.C.dirfd;
	alphasort = ffi.C.alphasort;
	scandir = ffi.C.scandir;
	--getdents = ffi.C.getdents;
	versionsort = ffi.C.versionsort;

	--dirent64 = ffi.C.dirent;
	readdir64 = ffi.C.readdir;
	readdir64_r = ffi.C.readdir_r;
	scandir64 = ffi.C.scandir;
	alphasort64 = ffi.C.alphasort;
	versionsort64 = ffi.C.versionsort;
	--getdents64 = ffi.C.getdents;
}

local exports = {
	Constants = Constants;
	Functions = Functions;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Constants, tbl);
		utils.copyPairs(self.Functions, tbl);

		return self;
	end,
})

return exports;
