local ffi = require("ffi")
local utils = require("libc_utils")

require("sys/socket")

ffi.cdef[[
typedef uint16_t in_port_t;
typedef uint32_t in_addr_t;
]]

ffi.cdef[[
struct in_addr 
{ 
	in_addr_t s_addr; 
};
]]

ffi.cdef[[
struct sockaddr_in
{
	sa_family_t sin_family;
	in_port_t sin_port;
	struct in_addr sin_addr;
	uint8_t sin_zero[8];
};
]]

ffi.cdef[[
struct in6_addr
{
	union {
		uint8_t __s6_addr[16];
		uint16_t __s6_addr16[8];
		uint32_t __s6_addr32[4];
	} __in6_union;
};
]]
