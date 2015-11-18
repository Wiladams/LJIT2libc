--[[


	There is a mixture of these that actually needs to be implemented
	as the context of implementation is the 'C' environment within the 
	LuaJIT ffi.

	The basic integer types, complex types, are already defined

	libc goes far beyond what is defined in the C99 standard though, 
	so items such as networking, state, and the like are also included
	because this is what has been found to be most useful.
--]]


-- somewhere within an application,the following will need to be 
-- setup.  If not, the relative paths will not work correctly
local function setup(homePath)
	local ffi = require("ffi")
	package.path = package.path..";"..homePath.."/arch/"..ffi.arch.."/?.lua"
	
--print("PACKAGE")
--print(package.path)

	local utils = require("libc_utils")

	local exports = {
		netinet_in = require("netinet/in_h");
		netinet_tcp = require("netinet/tcp");

		sys_auxv = require("sys/auxv");
		sys_epoll = require("sys/epoll");
		sys_ioctl = require("sys/ioctl");
		sys_socket = require("sys/socket");
		sys_stat = require("sys/stat");
		sys_syscall = require("sys/syscall");
		sys_types = require("sys/types");


		byteswap = require("byteswap");
		ctype = require("ctype");
		dirent = require("dirent");
		elf = require("elf");
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
		__call = function(self, tbl)
			for k,v in pairs(self) do
				local success, err = pcall(function() v(tbl) end)
			end

			return self
		end,

	})

	return exports
end

return setup
