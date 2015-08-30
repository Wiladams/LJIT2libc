local ffi = require("ffi")
local utils = require("libc_utils")

local alltypes = require("bits/alltypes")

ffi.cdef[[


typedef struct { int quot, rem; } div_t;
typedef struct { long quot, rem; } ldiv_t;
typedef struct { long long quot, rem; } lldiv_t;

div_t div (int, int);
ldiv_t ldiv (long, long);
lldiv_t lldiv (long long, long long);
 ]]


ffi.cdef[[
extern double atof (const char *nptr);
extern int atoi (const char *nptr);
extern long int atol (const char *nptr);

extern long long int atoll (const char *__nptr);	// C99

extern double strtod (const char * nptr, char ** endptr);
]]

ffi.cdef[[
void *aligned_alloc(size_t alignment, size_t size);
void * calloc(size_t nmemb, size_t size);
void free(void *);
void * malloc(const size_t size);
void * realloc(void *ptr, size_t size);
]]

ffi.cdef[[
int rand (void);
void srand (unsigned);
]]

ffi.cdef[[
void abort (void);
int atexit (void (*) (void));
void exit (int);
int at_quick_exit (void (*) (void));
void quick_exit (int);
]]

ffi.cdef[[
char *getenv (const char *);
int system (const char *);
]]

ffi.cdef[[
void *bsearch (const void *, const void *, size_t, size_t, int (*)(const void *, const void *));
void qsort (void *, size_t, size_t, int (*)(const void *, const void *));

int abs (int);
long labs (long);
long long llabs (long long);
]]

ffi.cdef[[
int mblen (const char *, size_t);
int mbtowc (wchar_t *__restrict, const char *__restrict, size_t);
int wctomb (char *, wchar_t);
size_t mbstowcs (wchar_t *__restrict, const char *__restrict, size_t);
size_t wcstombs (char *__restrict, const wchar_t *__restrict, size_t);
]]


local Constants = {
	-- The largest number rand will return (same as INT_MAX).
	RAND_MAX = 0x7fffffff;
	EXIT_FAILURE	= 1;	-- Failing exit status.
	EXIT_SUCCESS	= 0;	-- Successful exit status.
}

local Functions = {
	-- numeric parsing
	atof = ffi.C.atof;
	atoi = ffi.C.atoi;
	atol = ffi.C.atol;
	atoll = ffi.C.atoll;
	strtod = ffi.C.strtod;

	-- memory allocation
	aligned_alloc = ffi.C.aligned_alloc;
	malloc = ffi.C.malloc;
	free = ffi.C.free;
	calloc = ffi.C.calloc;
	realloc = ffi.C.realloc;

	-- exiting
	abort = ffi.C.abort;
	--atexit = ffi.C.atexit;
	exit = ffi.C.exit;
	--at_quick_exit = ffi.C.at_quick_exit;
	quick_exit = ffi.C.quick_exit;

	-- system related
	getenv = ffi.C.getenv;
	system = ffi.C.system;

	-- Miscellany
	bsearch = ffi.C.bsearch;
	qsort = ffi.C.qsort;

	abs = ffi.C.abs;
	labs = ffi.C.labs;
	llabs = ffi.C.llabs;

	-- multi-byte character conversions
	mblen = ffi.C.mblen;
	mbtowc = ffi.C.mbtowc;
	wctomb = ffi.C.wctomb;
	mbstowcs = ffi.C.mbstowcs;
	wcstombs = ffi.C.wcstombs;
}

local exports = {
	Constants = Constants;
	Functions = Functions;
}


setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Constants, tbl)
		utils.copyPairs(self.Functions, tbl)

		return self
	end,
})

return exports
