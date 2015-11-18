local ffi = require("ffi")
local utils = require("libc_utils")
local octal = utils.octal

local O_NONBLOCK   = octal('04000')

ffi.cdef[[
static const int	O_ACCMODE	= 00000003;
static const int	O_RDONLY	= 00000000;
static const int	O_WRONLY	= 00000001;
static const int	O_RDWR		= 00000002;
]]

local Constants = {

	O_CREAT     = octal('0100');
	O_EXCL      = octal('0200');
	O_NOCTTY    = octal('0400');
	O_TRUNC     = octal('01000');
	O_APPEND    = octal('02000');
	O_NONBLOCK  = O_NONBLOCK;
	O_DSYNC    	= octal('010000');
	O_SYNC    	= octal('04010000');
	O_RSYNC   	= octal('04010000');
	O_DIRECTORY = octal('0200000');
	O_NOFOLLOW 	= octal('0400000');
	O_CLOEXEC 	= octal('02000000');

	O_ASYNC     = octal('020000');
	O_DIRECT    = octal('040000');
	O_LARGEFILE = 0;
	O_NOATIME  	= octal('01000000');
	O_PATH    	= octal('010000000');
	O_TMPFILE 	= octal('020200000');
	O_NDELAY 	= O_NONBLOCK;

	F_DUPFD  = 0;
	F_GETFD  = 1;
	F_SETFD  = 2;
	F_GETFL  = 3;
	F_SETFL  = 4;

	F_SETOWN = 8;
	F_GETOWN = 9;
	F_SETSIG = 10;
	F_GETSIG = 11;

	F_GETLK = 5;
	F_SETLK = 6;
	F_SETLKW = 7;

	F_SETOWN_EX = 15;
	F_GETOWN_EX = 16;

	F_GETOWNER_UIDS = 17;
}

return Constants


