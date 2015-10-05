local ffi = require("ffi")

local _STAT_VER_KERNEL	= 0;
local _STAT_VER_LINUX	= 1;

 _STAT_VER	=	_STAT_VER_LINUX;

--[[
-- from GNU header
struct stat
  {
    __dev_t st_dev;		/* Device.  */
    __ino_t st_ino;		/* File serial number.	*/
    __nlink_t st_nlink;		/* Link count.  */
    __mode_t st_mode;		/* File mode.  */
    __uid_t st_uid;		/* User ID of the file's owner.	*/
    __gid_t st_gid;		/* Group ID of the file's group.*/
    int __pad0;
    __dev_t st_rdev;		/* Device number, if device.  */
    __off_t st_size;			/* Size of file, in bytes.  */
    __blksize_t st_blksize;	/* Optimal block size for I/O.  */
    __blkcnt_t st_blocks;		/* Number 512-byte blocks allocated. */
    struct timespec st_atim;		/* Time of last access.  */
    struct timespec st_mtim;		/* Time of last modification.  */
    struct timespec st_ctim;		/* Time of last status change.  */
    __syscall_slong_t __glibc_reserved[3];
  };
--]]

ffi.cdef[[
struct stat {
	dev_t st_dev;
	ino_t st_ino;
	nlink_t st_nlink;

	mode_t st_mode;
	uid_t st_uid;
	gid_t st_gid;
	unsigned int    __pad0;
	dev_t st_rdev;
	off_t st_size;
	blksize_t st_blksize;
	blkcnt_t st_blocks;

	struct timespec st_atim;
	struct timespec st_mtim;
	struct timespec st_ctim;
	long __unused[3];
};
]]
