local ffi = require("ffi")
local utils = require("libc_utils")

--local bits_alltypes = require ("bits/alltypes")
local alltypes = require("alltypes")
local bits_fcntl = require ("bits/fcntl")

ffi.cdef[[
struct flock
{
	short l_type;
	short l_whence;
	off_t l_start;
	off_t l_len;
	pid_t l_pid;
};
]]

ffi.cdef[[
int creat(const char *, mode_t);
int fcntl(int, int, ...);
int open(const char *, int, ...);
int openat(int, const char *, int, ...);
int posix_fadvise(int, off_t, off_t, int);
int posix_fallocate(int, off_t, off_t);
]]

local Functions = {
	creat = ffi.C.creat;
	fcntl =  ffi.C.fcntl;
	open =  ffi.C.open;
	openat =  ffi.C.openat;
	posix_fadvise =  ffi.C.posix_fadvise;
	posix_fallocate =  ffi.C.posix_fallocate;
}

local exports = {
	Functions = Functions;	
}

return exports
