

local ffi = require("ffi")
local utils = require("libc_utils")

--require ("bits/alltypes")

ffi.cdef[[
typedef int8_t int_fast8_t;
typedef int64_t int_fast64_t;

typedef int8_t  int_least8_t;
typedef int16_t int_least16_t;
typedef int32_t int_least32_t;
typedef int64_t int_least64_t;

typedef uint8_t uint_fast8_t;
typedef uint64_t uint_fast64_t;

typedef uint8_t  uint_least8_t;
typedef uint16_t uint_least16_t;
typedef uint32_t uint_least32_t;
typedef uint64_t uint_least64_t;
]]



local	INT8_MIN   =(-1-0x7f);
local	INT16_MIN  =(-1-0x7fff);
local	INT32_MIN  =(-1-0x7fffffff);
local	INT64_MIN  =(-1LL-0x7fffffffffffffffLL);

local	INT8_MAX   =0x7f;
local	INT16_MAX  =0x7fff;
local	INT32_MAX  =0x7fffffff;
local	INT64_MAX  =0x7fffffffffffffffLL;

local	UINT8_MAX  =(0xff);
local	UINT16_MAX =(0xffff);
local	UINT32_MAX =(0xffffffff);
local	UINT64_MAX =(0xffffffffffffffffULL);


local Constants = {
	INT8_MIN =INT8_MIN;
	INT16_MIN=INT16_MIN;
	INT32_MIN=INT32_MIN;
	INT64_MIN=INT64_MIN;

	INT8_MAX=INT8_MAX;
	INT16_MAX=INT16_MAX;
	INT32_MAX=INT32_MAX;
	INT64_MAX=INT64_MAX;

	UINT8_MAX=UINT8_MAX;
	UINT16_MAX=UINT16_MAX;
	UINT32_MAX=UINT32_MAX;
	UINT64_MAX=UINT64_MAX;

	INT_FAST8_MIN   =INT8_MIN;
	INT_FAST64_MIN  =INT64_MIN;

	INT_LEAST8_MIN   =INT8_MIN;
	INT_LEAST16_MIN  =INT16_MIN;
	INT_LEAST32_MIN  =INT32_MIN;
	INT_LEAST64_MIN  =INT64_MIN;

	INT_FAST8_MAX   =INT8_MAX;
	INT_FAST64_MAX  =INT64_MAX;

	INT_LEAST8_MAX   =INT8_MAX;
	INT_LEAST16_MAX  =INT16_MAX;
	INT_LEAST32_MAX  =INT32_MAX;
	INT_LEAST64_MAX  =INT64_MAX;

	UINT_FAST8_MAX  =UINT8_MAX;
	UINT_FAST64_MAX =UINT64_MAX;

	UINT_LEAST8_MAX  =UINT8_MAX;
	UINT_LEAST16_MAX =UINT16_MAX;
	UINT_LEAST32_MAX =UINT32_MAX;
	UINT_LEAST64_MAX =UINT64_MAX;

	INTMAX_MIN  =INT64_MIN;
	INTMAX_MAX  =INT64_MAX;
	UINTMAX_MAX =UINT64_MAX;

	WINT_MIN = 0;
	WINT_MAX =UINT32_MAX;

	SIG_ATOMIC_MIN  = INT32_MIN;
	SIG_ATOMIC_MAX  = INT32_MAX;
}

local bits_stdint = require ("bits/stdint")(Constants)


local exports = {
	Constants;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Constants, tbl);
		utils.copyPairs(bits_stdint, tbl);

		return self;
	end,
})

-- Need to figure out how to do the 'L' thing to make this work
--[[
#if L'\0'-1 > 0
#define WCHAR_MAX (0xffffffffu+L'\0')
#define WCHAR_MIN (0+L'\0')
#else
#define WCHAR_MAX (0x7fffffff+L'\0')
#define WCHAR_MIN (-1-0x7fffffff+L'\0')
#endif
--]]

-- These are lexical macros.  Maybe not necessary?
-- or perhaps rarely seen in the wild?
--[[
#define INT8_C(c)  c
#define INT16_C(c) c
#define INT32_C(c) c

#define UINT8_C(c)  c
#define UINT16_C(c) c
#define UINT32_C(c) c ## U

#if UINTPTR_MAX == UINT64_MAX
#define INT64_C(c) c ## LL
#define UINT64_C(c) c ## ULL
#define INTMAX_C(c)  c ## L
#define UINTMAX_C(c) c ## UL
#else
#define INT64_C(c) c ## LL
#define UINT64_C(c) c ## ULL
#define INTMAX_C(c)  c ## LL
#define UINTMAX_C(c) c ## ULL
#endif
--]]

