-- test_syscall.lua
-- Contains various syscall wrappers for Linux
local libc = require("libc")
local ffi = require("ffi")

local u64 = ffi.typeof("uint64_t")

-- TODO could make these return errno here, also are these best casts?
local syscall_long = libc.syscall -- returns long


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


-- return helpers
local function retnum(ret, err) -- return Lua number where double precision ok, eg file ops etc
  ret = tonumber(ret)
  if ret == -1 then return nil, t.error(err or errno()) end
  return ret
end

local function retfd(ret, err)
  if ret == -1 then return nil, t.error(err or errno()) end
  return t.fd(ret)
end

-- used for no return value, return true for use of assert
local function retbool(ret, err)
  if ret == -1 then return nil, t.error(err or errno()) end
  return true
end



-- used for pointer returns, -1 is failure
local function retptr(ret, err)
  if ret == errpointer then return nil, t.error(err or errno()) end
  return ret
end









--[[
static const int __NR_read				=0;
static const int __NR_write				=1;
static const int __NR_open				=2;
static const int __NR_close				=3;
static const int __NR_stat				=4;
--]]









local E = {}

function E.settimeofday(tv, tz)
  return syscall(libc.__NR_settimeofday, void(tv), void(tz))
end

function E.getrandom(buf, buflen, flags)
	flags = flags or 0
	return syscall(libc.__NR_getrandom, void(buf), size_t(buflen), uint(flags))
end


return E
