local ffi = require("ffi")

ffi.cdef[[
typedef struct
{
    int quot;			/* Quotient.  */
    int rem;			/* Remainder.  */
} div_t;

typedef struct
{
    long int quot;		/* Quotient.  */
    long int rem;		/* Remainder.  */
} ldiv_t;
 ]]


ffi.cdef[[
extern double atof (const char *nptr);
extern int atoi (const char *nptr);
extern long int atol (const char *nptr);

extern long long int atoll (const char *__nptr);	// C99

extern double strtod (const char * nptr, char ** endptr);
]]

ffi.cdef[[
void * malloc(const size_t size);
void free(void *);
void * calloc(size_t nmemb, size_t size);
void * realloc(void *ptr, size_t size);
]]

local Constants = {
	-- The largest number rand will return (same as INT_MAX).
	RAND_MAX = 2147483647;
	EXIT_FAILURE	= 1;	-- Failing exit status.
	EXIT_SUCCESS	= 0;	-- Successful exit status.
}

local Functions = {
	malloc = ffi.C.malloc;
	free = ffi.C.free;
	calloc = ffi.C.calloc;
	realloc = ffi.C.realloc;
}

local exports = {
	Constants = Constants;
}

setmetatable(exports, {
	__call = function(self, library)
		for k,v in pairs(self) do
			_G[k] = v;
		end

		return self
	end,
})

return exports
