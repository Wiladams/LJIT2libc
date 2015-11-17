--libc.lua

local ffi = require("ffi")

local exports = {
	netinet_in = require("netinet/in_h");
	netinet_tcp = require("netinet/tcp");

	sys_epoll = require("sys/epoll");
	sys_ioctl = require("sys/ioctl");
	sys_socket = require("sys/socket");
	sys_stat = require("sys/stat");
	sys_syscall = require("sys/syscall");
	sys_types = require("sys/types");


	byteswap = require("byteswap");
	ctype = require("ctype");
	dirent = require("dirent");
	errno = require("errno");
	fcntl = require("fcntl");
	libgen = require("libgen");
	stdint = require("stdint");
	stdio = require("stdio");
	stdlib = require("stdlib");
	string_h = require("string_h");
	unistd = require("unistd");
}

setmetatable(exports, {
	__index = function(self, key)
		-- First, see if it's one of the functions or constants
		-- in the library
		local success, value = pcall(function() return ffi.C[key] end)
		if success then
			rawset(self, key, value)
			return value;
		end

		-- try to find the key as a type
		success, value = pcall(function() return ffi.typeof(key) end)
		if success then
			rawset(key, value)
			return value;
		end

		-- finally, return nil if it's nothing we can get to easily
		return nil;
	end,

})

return exports
