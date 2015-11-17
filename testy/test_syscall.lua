-- test_syscall.lua
local init = require("test_setup")()
local libc = require("libc")
local ffi = require("ffi")

local u64 = ffi.typeof("uint64_t")

-- TODO could make these return errno here, also are these best casts?
local syscall_long = libc.syscall -- returns long

print("syscall_long: ", syscall_long)

local function syscall(...) return tonumber(syscall_long(...)) end -- int is default as most common
local function syscall_uint(...) return uint(syscall_long(...)) end
local function syscall_void(...) return void(syscall_long(...)) end
local function syscall_off(...) return u64(syscall_long(...)) end -- off_t

local longstype = ffi.typeof("long[?]")
local uint = ffi.typeof("unsigned int")
local size_t = ffi.typeof("size_t")
local void = ffi.typeof("void *")


local function longs(...)
  local n = select('#', ...)
  local ll = ffi.new(longstype, n)
  for i = 1, n do
    ll[i - 1] = ffi.cast(long, select(i, ...))
  end
  return ll
end

local function settimeofday(tv, tz)
  return syscall(libc.__NR_settimeofday, void(tv), void(tz))
end

local function getrandom(buf, buflen, flags)
	flags = flags or 0
	return syscall(libc.__NR_getrandom, void(buf), size_t(buflen), uint(flags))
end

local buf = ffi.new("char [32]");
local buflen = 32;

local GRND_NONBLOCK	= 0x0001;
local GRND_RANDOM	= 0x0002;

print("getrandom: ", getrandom(buf, buflen, GRND_RANDOM));
