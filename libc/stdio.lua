-- stdio.lua
local ffi = require("ffi")
local utils = require("libc_utils")
local alltypes = require("alltypes")



ffi.cdef[[
typedef union _G_fpos64_t {
	char __opaque[16];
	double __align;
} fpos_t;

typedef fpos_t	fpos64_t;
typedef off_t	off64_t;

]]

ffi.cdef[[
extern FILE *const stdin;
extern FILE *const stdout;
extern FILE *const stderr;
]]


ffi.cdef[[
FILE *fopen(const char *__restrict, const char *__restrict);
FILE *freopen(const char *__restrict, const char *__restrict, FILE *__restrict);
int fclose(FILE *);

int remove(const char *);
int rename(const char *, const char *);

int feof(FILE *);
int ferror(FILE *);
int fflush(FILE *);
void clearerr(FILE *);

int fseek(FILE *, long, int);
long ftell(FILE *);
void rewind(FILE *);

int fgetpos(FILE *__restrict, fpos_t *__restrict);
int fsetpos(FILE *, const fpos_t *);

size_t fread(void *__restrict, size_t, size_t, FILE *__restrict);
size_t fwrite(const void *__restrict, size_t, size_t, FILE *__restrict);

int fgetc(FILE *);
int getc(FILE *);
int getchar(void);
int ungetc(int, FILE *);

int fputc(int, FILE *);
int putc(int, FILE *);
int putchar(int);

char *fgets(char *__restrict, int, FILE *__restrict);
char *gets(char *);

int fputs(const char *__restrict, FILE *__restrict);
int puts(const char *);


int printf(const char *__restrict, ...);
int fprintf(FILE *__restrict, const char *__restrict, ...);
int sprintf(char *__restrict, const char *__restrict, ...);
int snprintf(char *__restrict, size_t, const char *__restrict, ...);

//int vprintf(const char *__restrict, __isoc_va_list);
//int vfprintf(FILE *__restrict, const char *__restrict, __isoc_va_list);
//int vsprintf(char *__restrict, const char *__restrict, __isoc_va_list);
//int vsnprintf(char *__restrict, size_t, const char *__restrict, __isoc_va_list);

int scanf(const char *__restrict, ...);
int fscanf(FILE *__restrict, const char *__restrict, ...);
int sscanf(const char *__restrict, const char *__restrict, ...);
//int vscanf(const char *__restrict, __isoc_va_list);
//int vfscanf(FILE *__restrict, const char *__restrict, __isoc_va_list);
//int vsscanf(const char *__restrict, const char *__restrict, __isoc_va_list);

void perror(const char *);

int setvbuf(FILE *__restrict, char *__restrict, int, size_t);
void setbuf(FILE *__restrict, char *__restrict);

char *tmpnam(char *);
FILE *tmpfile(void);
]]

-- GNU, BSD
ffi.cdef[[

// Posix, XOpen, GNU, BSD
FILE *fmemopen(void *__restrict, size_t, const char *__restrict);
FILE *open_memstream(char **, size_t *);
FILE *fdopen(int, const char *);
FILE *popen(const char *, const char *);
int pclose(FILE *);
int fileno(FILE *);
int fseeko(FILE *, off_t, int);
off_t ftello(FILE *);
int dprintf(int, const char *__restrict, ...);
//int vdprintf(int, const char *__restrict, __isoc_va_list);
void flockfile(FILE *);
int ftrylockfile(FILE *);
void funlockfile(FILE *);
int getc_unlocked(FILE *);
int getchar_unlocked(void);
int putc_unlocked(int, FILE *);
int putchar_unlocked(int);
ssize_t getdelim(char **__restrict, size_t *__restrict, int, FILE *__restrict);
ssize_t getline(char **__restrict, size_t *__restrict, FILE *__restrict);
int renameat(int, const char *, int, const char *);
char *ctermid(char *);

char *tempnam(const char *, const char *);
]]

-- GNU, BSD
ffi.cdef[[
char *cuserid(char *);
void setlinebuf(FILE *);
void setbuffer(FILE *, char *, size_t);
int fgetc_unlocked(FILE *);
int fputc_unlocked(int, FILE *);
int fflush_unlocked(FILE *);
size_t fread_unlocked(void *, size_t, size_t, FILE *);
size_t fwrite_unlocked(const void *, size_t, size_t, FILE *);
void clearerr_unlocked(FILE *);
int feof_unlocked(FILE *);
int ferror_unlocked(FILE *);
int fileno_unlocked(FILE *);
int getw(FILE *);
int putw(int, FILE *);
char *fgetln(FILE *, size_t *);
int asprintf(char **, const char *, ...);
//int vasprintf(char **, const char *, __isoc_va_list);
]]

-- GNU
ffi.cdef[[
char *fgets_unlocked(char *, int, FILE *);
int fputs_unlocked(const char *, FILE *);
]]


local Constants = {
	EOF = -1;

	SEEK_SET =0;
	SEEK_CUR =1;
	SEEK_END =2;

	_IOFBF =0;
	_IOLBF =1;
	_IONBF =2;

	BUFSIZ =1024;
	FILENAME_MAX =4096;
	FOPEN_MAX =1000;
	TMP_MAX =10000;
	L_tmpnam =20;
	L_ctermid = 20;

	P_tmpdir = "/tmp";
	L_cuserid = 20;

}

local Functions = {
	fclose = ffi.C.fclose;
	fopen = ffi.C.fopen;
	fscanf = ffi.C.fscanf;
	printf = ffi.C.printf;
	puts = ffi.C.puts;
	scanf = ffi.C.scanf;
	sscanf = ffi.C.sscanf;
	
	-- GNU 64-bit specific
	tmpfile64 = ffi.C.tmpfile;
	fopen64 = ffi.C.fopen;
	freopen64  = ffi.C.freopen;
	fseeko64  = ffi.C.fseeko;
	ftello64  = ffi.C.ftello;
	fgetpos64  = ffi.C.fgetpos;
	fsetpos64  = ffi.C.fsetpos;
}

local Types = {
	
}

local exports = {
	Constants = Constants;
	Functions = Functions;
}

setmetatable(exports, {
	__call = function(self, ...)
		utils.copyPairs(self.Constants);
		utils.copyPairs(self.Functions);

		return self;
	end,
})

return exports
