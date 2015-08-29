# LJIT2libc
LuaJIT binding to libc

Why a binding to libc?
Because I keep pulling in things from libc, sprinkling those ffi.cdefs all over my various projects.  This one is meant to be the gethering place for all things libc.

In addition to being the gathering place, it keeps it in isolation from other larger projects.  For example, ljsyscall has a lot of this, as does libuv, but it's in the context of those larger projects.  What's here is just libc stuff, with higher level frameworks doing their own work, possibly pulling from these sources.

The source for these definitions are multiple.  Looking at standard libc libraries, such as GNU and musl.  Also, looking at past luajit ffi work where it exists.  The goals are to be as correct as possible, taking into account any platform differences where they exist.

If you are converting code from C to lua, you should be able to leverage these bindings and have the look and feel of C.  Over time, some of the bindings may turn into luajit implementations.  That will make them more portable, and potentially faster.  But, the primary goal of this project is to simply capture as much of libc as is useful.

