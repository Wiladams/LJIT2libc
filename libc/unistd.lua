local ffi = require("ffi")

require("bits/alltypes")

ffi.cdef[[
int pipe(int [2]);
int pipe2(int [2], int);
int close(int);
int posix_close(int, int);
int dup(int);
int dup2(int, int);
int dup3(int, int, int);
off_t lseek(int, off_t, int);
int fsync(int);
int fdatasync(int);

ssize_t read(int, void *, size_t);
ssize_t write(int, const void *, size_t);
ssize_t pread(int, void *, size_t, off_t);
ssize_t pwrite(int, const void *, size_t, off_t);

int chown(const char *, uid_t, gid_t);
int fchown(int, uid_t, gid_t);
int lchown(const char *, uid_t, gid_t);
int fchownat(int, const char *, uid_t, gid_t, int);

int link(const char *, const char *);
int linkat(int, const char *, int, const char *, int);
int symlink(const char *, const char *);
int symlinkat(const char *, int, const char *);
ssize_t readlink(const char *__restrict, char *__restrict, size_t);
ssize_t readlinkat(int, const char *__restrict, char *__restrict, size_t);
int unlink(const char *);
int unlinkat(int, const char *, int);
int rmdir(const char *);
int truncate(const char *, off_t);
int ftruncate(int, off_t);
]]

ffi.cdef[[
static const int F_OK = 0;
static const int R_OK = 4;
static const int W_OK = 2;
static const int X_OK = 1;

int access(const char *, int);
int faccessat(int, const char *, int, int);

int chdir(const char *);
int fchdir(int);
char *getcwd(char *, size_t);

unsigned alarm(unsigned);
unsigned sleep(unsigned);
int pause(void);

pid_t fork(void);
int execve(const char *, char *const [], char *const []);
int execv(const char *, char *const []);
int execle(const char *, const char *, ...);
int execl(const char *, const char *, ...);
int execvp(const char *, char *const []);
int execlp(const char *, const char *, ...);
int fexecve(int, char *const [], char *const []);
void _exit(int);
]]

ffi.cdef[[
pid_t getpid(void);
pid_t getppid(void);
pid_t getpgrp(void);
pid_t getpgid(pid_t);
int setpgid(pid_t, pid_t);
pid_t setsid(void);
pid_t getsid(pid_t);
char *ttyname(int);
int ttyname_r(int, char *, size_t);
int isatty(int);
pid_t tcgetpgrp(int);
int tcsetpgrp(int, pid_t);

uid_t getuid(void);
uid_t geteuid(void);
gid_t getgid(void);
gid_t getegid(void);
int getgroups(int, gid_t []);
int setuid(uid_t);
int setreuid(uid_t, uid_t);
int seteuid(uid_t);
int setgid(gid_t);
int setregid(gid_t, gid_t);
int setegid(gid_t);
]]


ffi.cdef[[
char *getlogin(void);
int getlogin_r(char *, size_t);
int gethostname(char *, size_t);
char *ctermid(char *);
]]

ffi.cdef[[
int getopt(int, char * const [], const char *);
extern char *optarg;
extern int optind, opterr, optopt;
]]

ffi.cdef[[
long pathconf(const char *, int);
long fpathconf(int, int);
long sysconf(int);
size_t confstr(int, char *, size_t);
]]

ffi.cdef[[
static const int F_ULOCK = 0;
static const int F_LOCK  = 1;
static const int F_TLOCK = 2;
static const int F_TEST  = 3;
]]

ffi.cdef[[
//#if defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
int lockf(int, int, off_t);
long gethostid(void);
int nice(int);
void sync(void);
pid_t setpgrp(void);
char *crypt(const char *, const char *);
void encrypt(char *, int);
void swab(const void *__restrict, void *__restrict, ssize_t);
//#endif
]]

ffi.cdef[[
//#if defined(_GNU_SOURCE) || defined(_BSD_SOURCE) || (defined(_XOPEN_SOURCE) && _XOPEN_SOURCE+0 < 700)
int usleep(unsigned int);
unsigned ualarm(unsigned int, unsigned int);
//#endif
]]

ffi.cdef[[
//#if defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
static const int L_SET  = 0;
static const int L_INCR = 1;
static const int L_XTND = 2;

int brk(void *);
void *sbrk(intptr_t);
pid_t vfork(void);
int vhangup(void);
int chroot(const char *);
int getpagesize(void);
int getdtablesize(void);
int sethostname(const char *, size_t);
int getdomainname(char *, size_t);
int setdomainname(const char *, size_t);
int setgroups(size_t, const gid_t *);
char *getpass(const char *);
int daemon(int, int);
void setusershell(void);
void endusershell(void);
char *getusershell(void);
int acct(const char *);
long syscall(long, ...);
int execvpe(const char *, char *const [], char *const []);
int issetugid(void);
//#endif
]]

ffi.cdef[[
//#ifdef _GNU_SOURCE
extern char **environ;
int setresuid(uid_t, uid_t, uid_t);
int setresgid(gid_t, gid_t, gid_t);
int getresuid(uid_t *, uid_t *, uid_t *);
int getresgid(gid_t *, gid_t *, gid_t *);
char *get_current_dir_name(void);
int syncfs(int);
int euidaccess(const char *, int);
int eaccess(const char *, int);
//#endif
]]

local exports = {
	
}

return exports
