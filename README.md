# LJIT2libc
LuaJIT binding to libc

Why a binding to libc?
Because I keep pulling in things from libc, sprinkling those ffi.cdefs all over my various projects.  This one is meant to be the gethering place for all things libc.

In addition to being the gathering place, it keeps it in isolation from other larger projects.  For example, ljsyscall has a lot of this, as does libuv, but it's in the context of those larger projects.  What's here is just libc stuff, with higher level frameworks doing their own work, possibly pulling from these sources.

The sources for these definitions are multiple.  Looking at standard libc libraries, such as GNU and musl.  Also, looking at past luajit ffi work (such as LAPHLibs) where it exists.  The goals are to be as correct as possible, taking into account any platform differences where they exist.

If you are converting code from C to lua, you should be able to leverage these bindings and have the look and feel of C.  Over time, some of the bindings may turn into luajit implementations.  That will make them more portable, and potentially faster.  But, the primary goal of this project is to simply capture as much of libc as is useful.

One thing to keep in mind is that the C functions are just as dangerous, in terms of memory management, as they are when you're 
using them from straight C.  The luajit does not do anything to make
them any safer, it just provides ready access to the routines.

In many case, such as the string routines, you're dealing with raw
pointers, with all the potential for buffer overruns and the like
that exist when you're using the routines from C.

C99 standard headers
*	assert.h
*	complex.h
*	ctype.h
*	errno.h
*	fenv.h
*	float.h
*	inttypes.h
*	iso646.h
*	limits.h
*	locale.h
*	math.h
*	setjmp.h
*	signal.h
*	stdarg.h
*	stdbool.h
*	stddef.h
*	stdint.h
*	stdio.h
*	stdlib.h
*	string.h
*	tgmath.h
*	time.h
*	wchar.h
*	wctype.h


Design Considerations
---------------------
The libc library is fairly large, so the header files, containing constants, function declarations, macros and the like, are fairly big as well.  In creating this set, there should be an ability to only pull in the parts that you want, without having to drag in the whole thing.  At the same time, there are some global concerns, like setting the package path, which must be taken care of.

A balance must be achieved between making the various constants easily accessible while without unnecesarily polluting the global namespace.  This is typically achieved by implementing everything in a local scope, and providing an easy mechanism for exporting what's in those tables into the global namespace on an individual basis.

Here is a typical use case:

```local stdint = require("stdint")
print(stdint.Constants.INT32_MAX)'''

In this case, nothing is in the global namespace, and the constants can be accessed through the proper table access.  Although this is great, it makes porting typical C code very difficult as the table references must be placed everywhere.

Here is another way of doing it:

local stdint = require("stdint")(_G)
print(INT32_MAX)

In this case, the returned table has a '__call()' metamethod implemented (as do all files), which will copy the contents of the various tables into the passed in table (in this case the global table).  This still gives you the flexibility of keeping everything local, or exporting into a table of your choice.  If no table is specified, then the global table will be used.

The danger/challenge of using the global table like this is your code will become very slow as every single reference to the value will be a global table lookup.  In such cases, it still makes sense to make a local reference, if the number of occurences are fairly small.  So, if you don't need all of the Constants from stdint, only locally copy the ones you need:

local stdint = require("stdint")
local INT32_MAX = stdint.Constants.INT32_MAX;
local INT64_MAX = stdint.Constants.INT64_MAX;

print(INT32_MAX, INT64_MAX)

This has the advantage of faster usage, and possible optimization, while causing the code to write a little bit more code up front.  Which way you decide to use it may be determined by which tradeoff you're willing to make.  Probably going global in the beginning, and refining to tighter scoping as time goes on.
