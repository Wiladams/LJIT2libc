--[[
	C99 standard headers
	assert.h
	complex.h
	*ctype.h
	errno.h
	fenv.h
	float.h
	inttypes.h
	iso646.h
	limits.h
	locale.h
	math.h
	setjmp.h
	signal.h
	stdarg.h
	stdbool.h
	stddef.h
	stdint.h
	stdio.h
	stdlib.h
	string.h
	tgmath.h
	time.h
	wchar.h
	wctype.h

	There is a mixture of these that actually needs to be implemented
	as the context of implementation is the 'C' environment within the 
	LuaJIT ffi.

	The basic integer types, complex types, are already defined

	libc goes far beyond what is defined in the C99 standard though, 
	so items such as networking, state, and the like are also included
	because this is what has been found to be most useful.
--]]
require("netinet/in_h")
require("netinet/tcp")
require("sys/epoll")()
require("sys/stat")()
require("stdlib")()
