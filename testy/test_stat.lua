#!/usr/bin/env luajit 
-- test_stat.lua

local init = require("test_setup")()
local ffi = require("ffi")

local buf = ffi.new("struct stat")
print("buf: ", buf)
local res = stat("test_stat.lua", buf);

print("stat_res: ", res, errno_string())
print("size: ", tonumber(buf.st_size))

local lres = lstat("./test_stat.lua", buf);
print("lstat_res: ", lres, errno_string())