# LJIT2libc
LuaJIT binding to libc

Why a binding to libc?
Because I keep pulling in things from libc, sprinkling those ffi.cdefs all over my various projects.  This one is meant to be the gethering place for all things libc.

In addition to being the gathering place, it keeps it in isolation from other larger projects.  For example, ljsyscall has a lot of this, as does libuv, but it's in the context of those larger projects.  What's here is just libc stuff, with higher level frameworks doing their own work, possibly pulling from these sources.
