#!/usr/bin/env luajit 
--lfiles.lua
local init = require("test_setup")()
local ffi = require("ffi")


-- iterate over the files in a directory
-- skip over '.' and '..' so we don't end 
-- up in infinite loops too easily
local function diriter(param, state)
	if state == nil then return nil end;
	local name = nil;
	while state ~= nil do
		name = ffi.string(state.d_name);
		if name ~= "." and name ~= ".." then
			break;
		end
		state = readdir(param);
	end

	if state == nil then return nil, nil; end

	local nextone = readdir(param)

	return nextone, name
end

local function iterateDirectory(dirname)
	local dir = opendir(dirname)


	if not dir==nil then return diriter, nil, nil; end

	-- make sure to do the finalizer
	-- for garbage collection
	ffi.gc(dir, closedir);

	local initial = readdir(dir);

	return diriter, dir, initial;
end


-- Simple test case to print out all the entries in a
-- given directory (default current directory)
local dirname = arg[1] or "./"
for _, entryName in iterateDirectory(dirname) do 
	print(entryName)
	stat(entryName)
end
