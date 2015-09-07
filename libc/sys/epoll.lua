local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift;

local utils = require("libc_utils")

ffi.cdef[[
/* Flags to be passed to epoll_create1.  */
enum
  {
    EPOLL_CLOEXEC = 02000000
  };
]]

ffi.cdef[[
typedef union epoll_data {
  void *ptr;
  int fd;
  uint32_t u32;
  uint64_t u64;
} epoll_data_t;
]]


ffi.cdef([[
struct epoll_event {
int32_t events;
epoll_data_t data;
}]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))



ffi.cdef[[
int epoll_create (int __size) ;
int epoll_create1 (int __flags) ;
int epoll_ctl (int __epfd, int __op, int __fd, struct epoll_event *__event) ;
int epoll_wait (int __epfd, struct epoll_event *__events, int __maxevents, int __timeout);

//int epoll_pwait (int __epfd, struct epoll_event *__events,
//          int __maxevents, int __timeout,
//          const __sigset_t *__ss);
]]


local exports = {
	epoll_create = ffi.C.epoll_create;
	epoll_create1 = ffi.C.epoll_create1;
	epoll_ctl = ffi.C.epoll_ctl;
	epoll_wait = ffi.C.epoll_wait;

	EPOLLIN 	= 0x0001;
	EPOLLPRI 	= 0x0002;
	EPOLLOUT 	= 0x0004;
	EPOLLRDNORM = 0x0040;			-- SAME AS EPOLLIN
	EPOLLRDBAND = 0x0080;
	EPOLLWRNORM = 0x0100;			-- SAME AS EPOLLOUT
	EPOLLWRBAND = 0x0200;
	EPOLLMSG	= 0x0400;			-- NOT USED
	EPOLLERR 	= 0x0008;
	EPOLLHUP 	= 0x0010;
	EPOLLRDHUP 	= 0x2000;
	EPOLLWAKEUP = lshift(1,29);
	EPOLLONESHOT = lshift(1,30);
	EPOLLET 	= lshift(1,31);




-- Valid opcodes ( "op" parameter ) to issue to epoll_ctl().
	EPOLL_CTL_ADD =1;	-- Add a file descriptor to the interface.
	EPOLL_CTL_DEL =2;	-- Remove a file descriptor from the interface.
	EPOLL_CTL_MOD =3;	-- Change file descriptor epoll_event structure.

}


setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyTable(exports, tbl)

		return self;
	end,
})

return exports
