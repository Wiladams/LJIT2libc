--alltypes.lua
local ffi = require("ffi")
require("bits/alltypes")

--[[
ffi.cdef[[
TYPEDEF unsigned _Addr size_t;
TYPEDEF unsigned _Addr uintptr_t;
TYPEDEF _Addr ptrdiff_t;
TYPEDEF _Addr ssize_t;
TYPEDEF _Addr intptr_t;
TYPEDEF _Addr regoff_t;
TYPEDEF _Reg register_t;
]]


ffi.cdef[[
typedef unsigned int mode_t;
typedef unsigned int nlink_t;
typedef int64_t off_t;
typedef uint64_t ino_t;
typedef uint64_t dev_t;
typedef long blksize_t;
typedef int64_t blkcnt_t;
typedef uint64_t fsblkcnt_t;
typedef uint64_t fsfilcnt_t;

typedef unsigned int wint_t;
typedef unsigned long wctype_t;

typedef void * timer_t;
typedef int clockid_t;
typedef long clock_t;

struct timeval { time_t tv_sec; suseconds_t tv_usec; };
struct timespec { time_t tv_sec; long tv_nsec; };

typedef int pid_t;
typedef unsigned int id_t;
typedef unsigned int uid_t;
typedef unsigned int gid_t;
typedef int key_t;
typedef unsigned int useconds_t;
]]

ffi.cdef[[
typedef struct _IO_FILE FILE;
]]