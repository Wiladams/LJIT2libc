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

--print("ARCH: ", ffi.arch)
package.path = package.path..";./arch/"..ffi.arch.."/?.lua"

local utils = require("libc_utils")

local exports = {
	netinet_in = require("netinet/in_h");
	netinet_tcp = require("netinet/tcp");
	sys_epoll = require("sys/epoll");
	sys_stat = require("sys/stat");
	stdlib = require("stdlib");
	stdint = require("stdint");
}

setmetatable(exports, {
	__call = function(self, tbl)
		for k,v in pairs(self) do
			v(tbl)
		end

		return self
	end,

})