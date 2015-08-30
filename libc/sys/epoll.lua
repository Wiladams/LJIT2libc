local ffi = require("ffi")
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
}


setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyTable(exports, tbl)

		return self;
	end,
})

return exports
