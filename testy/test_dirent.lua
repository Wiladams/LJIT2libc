--test_dirent.lua
local init = require("test_setup")()
local ffi = require("ffi")


local function openDirectory(dirname)
	local dir = opendir(dirname)
	print(dir)

	if dir == nil then 
		return false, "could not open directory"
	end
	ffi.gc(dir, closedir);

	return dir;
end

local dirname = arg[1] or "/"
local dir, err = openDirectory(dirname)

if not dir then return false end;

local entry = readdir(dir)
while (entry ~= nil) do 
	print(entry, ffi.string(entry.d_name))
	entry = readdir(dir)
end
