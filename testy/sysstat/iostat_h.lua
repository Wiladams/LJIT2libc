--[[
/*
 * iostat: report CPU and I/O statistics
 * (C) 1999-2015 by Sebastien Godard (sysstat <at> orange.fr)
 */
--]]
	ffi = require("ffi")
	bit = require("bit")
	band = bit.band;

--require ("common")


ffi.cdef[[
/*
 * Structures for I/O stats.
 * The number of structures allocated corresponds to the number of devices
 * present in the system, plus a preallocation number to handle those
 * that can be registered dynamically.
 * The number of devices is found by using /sys filesystem (if mounted).
 * For each io_stats structure allocated corresponds a io_hdr_stats structure.
 * A io_stats structure is considered as unused or "free" (containing no stats
 * for a particular device) if the 'major' field of the io_hdr_stats
 * structure is set to 0.
 */
struct io_stats {
	/* # of sectors read */
	unsigned long rd_sectors	__attribute__ ((aligned (8)));
	/* # of sectors written */
	unsigned long wr_sectors	__attribute__ ((packed));
	/* # of read operations issued to the device */
	unsigned long rd_ios		__attribute__ ((packed));
	/* # of read requests merged */
	unsigned long rd_merges		__attribute__ ((packed));
	/* # of write operations issued to the device */
	unsigned long wr_ios		__attribute__ ((packed));
	/* # of write requests merged */
	unsigned long wr_merges		__attribute__ ((packed));
	/* Time of read requests in queue */
	unsigned int  rd_ticks		__attribute__ ((packed));
	/* Time of write requests in queue */
	unsigned int  wr_ticks		__attribute__ ((packed));
	/* # of I/Os in progress */
	unsigned int  ios_pgr		__attribute__ ((packed));
	/* # of ticks total (for this device) for I/O */
	unsigned int  tot_ticks		__attribute__ ((packed));
	/* # of ticks requests spent in queue */
	unsigned int  rq_ticks		__attribute__ ((packed));
};
]]


ffi.cdef[[
/*
 * Each io_stats structure has an associated io_hdr_stats structure.
 * An io_hdr_stats structure tells if the corresponding device has been
 * unregistered or not (status field) and also indicates the device name.
 */
struct io_hdr_stats {
	unsigned int status		__attribute__ ((aligned (4)));
	unsigned int used		__attribute__ ((packed));
	char name[MAX_NAME_LEN];
};
]]


ffi.cdef[[
/* List of devices entered on the command line */
struct io_dlist {
	/* Indicate whether its partitions are to be displayed or not */
	int disp_part			__attribute__ ((aligned (4)));
	/* Device name */
	char dev_name[MAX_NAME_LEN];
};
]]



	Constants = {
	-- I_: iostat - D_: Display - F_: Flag
	I_D_CPU				= 0x00001;
	I_D_DISK			= 0x00002;
	I_D_TIMESTAMP		= 0x00004;
	I_D_EXTENDED		= 0x00008;
	I_D_PART_ALL		= 0x00010;
	I_D_KILOBYTES		= 0x00020;
	I_F_HAS_SYSFS		= 0x00040;
	I_D_DEBUG			= 0x00080;
	I_D_UNFILTERED		= 0x00100;
	I_D_MEGABYTES		= 0x00200;
	I_D_PARTITIONS		= 0x00400;
	I_F_HAS_DISKSTATS	= 0x00800;
	I_D_HUMAN_READ		= 0x01000;
	I_D_PERSIST_NAME	= 0x02000;
	I_D_OMIT_SINCE_BOOT	= 0x04000;
-- Unused			= 0x08000;
	I_D_DEVMAP_NAME		= 0x10000;
	I_D_ISO				= 0x20000;
	I_D_GROUP_TOTAL_ONLY	= 0x40000;
	I_D_ZERO_OMIT		= 0x80000; 

	IO_DLIST_SIZE		= (ffi.sizeof("struct io_dlist"));
	IO_HDR_STATS_SIZE	= (ffi.sizeof("struct io_hdr_stats"));
	IO_STATS_SIZE		= (ffi.sizeof("struct io_stats"));

	-- Possible values for field "status" in io_hdr_stats structure */
	DISK_UNREGISTERED	= 0;
	DISK_REGISTERED		= 1;
	DISK_GROUP			= 2;

-- Preallocation constants
	NR_DEV_PREALLOC		= 4;

-- Environment variable
	ENV_POSIXLY_CORRECT	= "POSIXLY_CORRECT";

}

	C = Constants;

Functions = {
	DISPLAY_CPU(m)			= return (band((m) , C.I_D_CPU)              == C.I_D_CPU) end;
	DISPLAY_DISK(m)			= return (band((m) , C.I_D_DISK)             == C.I_D_DISK) end;
	DISPLAY_TIMESTAMP(m)	= return (band((m) , C.I_D_TIMESTAMP)        == C.I_D_TIMESTAMP) end;
	DISPLAY_EXTENDED(m)		= return (band((m) , C.I_D_EXTENDED)         == C.I_D_EXTENDED) end;
	DISPLAY_PART_ALL(m)		= return (band((m) , C.I_D_PART_ALL)         == C.I_D_PART_ALL) end;
	DISPLAY_KILOBYTES(m)	= return (band((m) , C.I_D_KILOBYTES)        == C.I_D_KILOBYTES) end;
	DISPLAY_MEGABYTES(m)	= return (band((m) , C.I_D_MEGABYTES)        == C.I_D_MEGABYTES) end;
	HAS_SYSFS(m)			= return (band((m) , C.I_F_HAS_SYSFS)        == C.I_F_HAS_SYSFS) end;
	DISPLAY_DEBUG(m)		= return (band((m) , C.I_D_DEBUG)            == C.I_D_DEBUG) end;
	DISPLAY_UNFILTERED(m)	= return (band((m) , C.I_D_UNFILTERED)       == C.I_D_UNFILTERED) end;
	DISPLAY_PARTITIONS(m)	= return (band((m) , C.I_D_PARTITIONS)       == C.I_D_PARTITIONS) end;
	HAS_DISKSTATS(m)		= return (band((m) , C.I_F_HAS_DISKSTATS)    == C.I_F_HAS_DISKSTATS) end;
	DISPLAY_HUMAN_READ(m)	= return 	(band((m) , C.I_D_HUMAN_READ)       == C.I_D_HUMAN_READ) end;
	DISPLAY_PERSIST_NAME_I(m)	= return (band((m) , C.I_D_PERSIST_NAME)     == C.I_D_PERSIST_NAME) end;
	DISPLAY_OMIT_SINCE_BOOT(m)	= return (band((m) , C.I_D_OMIT_SINCE_BOOT)  == C.I_D_OMIT_SINCE_BOOT) end;
	DISPLAY_DEVMAP_NAME(m)		= return (band((m) , C.I_D_DEVMAP_NAME)      == C.I_D_DEVMAP_NAME) end;
	DISPLAY_ISO(m)			= return (band((m) , C.I_D_ISO)              == C.I_D_ISO) end;
	DISPLAY_GROUP_TOTAL_ONLY(m)	= return (band((m) , C.I_D_GROUP_TOTAL_ONLY) == C.I_D_GROUP_TOTAL_ONLY) end;
	DISPLAY_ZERO_OMIT(m)		= return (band((m) , C.I_D_ZERO_OMIT)        == C.I_D_ZERO_OMIT) end;
}






	exports = {
	Constants = Constants;
}

return exports
