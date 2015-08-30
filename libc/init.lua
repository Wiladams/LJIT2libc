--[[


	There is a mixture of these that actually needs to be implemented
	as the context of implementation is the 'C' environment within the 
	LuaJIT ffi.

	The basic integer types, complex types, are already defined

	libc goes far beyond what is defined in the C99 standard though, 
	so items such as networking, state, and the like are also included
	because this is what has been found to be most useful.
--]]

local ffi = require("ffi")

-- somewhere within an application,the following will need to be 
-- setup.  If not, the relative paths will not work correctly
package.path = package.path..";./arch/"..ffi.arch.."/?.lua"


local utils = require("libc_utils")

local exports = {
	netinet_in = require("netinet/in_h");
	netinet_tcp = require("netinet/tcp");

	sys_epoll = require("sys/epoll");
	sys_socket = require("sys/socket");
	sys_stat = require("sys/stat");
	sys_types = require("sys/types");


	byteswap = require("byteswap");
	ctype = require("ctype");
	fcntl = require("fcntl");
	stdint = require("stdint");
	stdlib = require("stdlib");
}

setmetatable(exports, {
	__call = function(self, tbl)
		for k,v in pairs(self) do
			v(tbl)
		end

		return self
	end,

})