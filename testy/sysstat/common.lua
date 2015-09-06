
--[[
  sar, sadc, sadf, mpstat and iostat common routines.

--]]

local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift;

require("common_h")

require("stdio")
require("string")
require("stdlib")
#include <time.h>
#include <errno.h>
#include <unistd.h>	--[[ For STDOUT_FILENO, among others --]]
#include <sys/ioctl.h>
#include <sys/types.h>
#include <dirent.h>
require ("ctype")
require ("libgen")

#include "version.h"
require("common_h")
#include "ioconf.h"
require("rd_stats_h")

--[[
#ifdef USE_NLS
#include <locale.h>
#include <libintl.h>
#define _(string) gettext(string)
#else
#define _(string) (string)
#endif
--]]


-- Maximum length of sensors device name */
	MAX_SENSORS_DEV_LEN	= 20;

--#include <time.h>
--#include <sched.h>	/* For __CPU_SETSIZE */
require ("rd_stats")




local DISP_HDR	= 1;

-- Number of seconds per day
local SEC_PER_DAY	= 3600 * 24;

-- Maximum number of CPUs
local NR_CPUS = 2048;
if __CPU_SETSIZE and __CPU_SETSIZE > 2048 then
NR_CPUS = __CPU_SETSIZE;
end

-- Maximum number of interrupts
local NR_IRQS =			1024;

-- Size of /proc/interrupts line, CPU data excluded
INTERRUPTS_LINE	= 128;

-- Keywords
K_ISO	="ISO";
K_ALL	="ALL";
K_UTC	="UTC";

-- Files
STAT			="/proc/stat";
UPTIME			="/proc/uptime";
DISKSTATS		="/proc/diskstats";
INTERRUPTS		="/proc/interrupts";
MEMINFO			="/proc/meminfo";
SYSFS_BLOCK		="/sys/block";
SYSFS_DEV_BLOCK		="/sys/dev/block";
SYSFS_DEVCPU		="/sys/devices/system/cpu";
SYSFS_TIME_IN_STATE	="cpufreq/stats/time_in_state";
S_STAT			="stat";
DEVMAP_DIR		="/dev/mapper";
DEVICES			="/proc/devices";
SYSFS_USBDEV		="/sys/bus/usb/devices";
DEV_DISK_BY		="/dev/disk/by";
SYSFS_IDVENDOR		="idVendor";
SYSFS_IDPRODUCT		="idProduct";
SYSFS_BMAXPOWER		="bMaxPower";
SYSFS_MANUFACTURER	="manufacturer";
SYSFS_PRODUCT		="product";
SYSFS_FCHOST		="/sys/class/fc_host";

MAX_FILE_LEN		=256;
MAX_PF_NAME		=1024;
MAX_NAME_LEN		=128;

IGNORE_VIRTUAL_DEVICES	=false;
ACCEPT_VIRTUAL_DEVICES	=true;

-- Environment variables
ENV_TIME_FMT		="S_TIME_FORMAT";
ENV_TIME_DEFTM		="S_TIME_DEF_TIME";

DIGITS			="0123456789";

--[[
/*
 ***************************************************************************
 * Macro functions definitions.
 ***************************************************************************
 */

/* Allocate and init structure */
local function SREALLOC(S, TYPE, SIZE)	
								 
   					TYPE *_p_;						 
				   	_p_ = S;						 
   				   	if (SIZE) {						 
   				      		if ((S = (TYPE *) realloc(S, (SIZE))) == NULL) { 
				         		perror("realloc");			 
				         		exit(4);				 
				      		}						 
				      		-- If the ptr was null, then it's a malloc()
   				      		if (!_p_)					 
      				         		memset(S, 0, (SIZE));			 
				   	}
end

/*
 * Macros used to display statistics values.
 *
 * NB: Define SP_VALUE() to normalize to %;
 * HZ is 1024 on IA64 and % should be normalized to 100.
 */
#define S_VALUE(m,n,p)	(((double) ((n) - (m))) / (p) * HZ)
#define SP_VALUE(m,n,p)	(((double) ((n) - (m))) / (p) * 100)

/*
 * Under very special circumstances, STDOUT may become unavailable.
 * This is what we try to guess here.
 */
#define TEST_STDOUT(_fd_)	do {					\
					if (write(_fd_, "", 0) == -1) {	\
				        	perror("stdout");	\
				       		exit(6);		\
				 	}				\
				} while (0)

#define MINIMUM(a,b)	((a) < (b) ? (a) : (b))

#define PANIC(m)	sysstat_panic(__FUNCTION__, m)

/* Number of ticks per second */
#define HZ		hz


/*
 * kB <-> number of pages.
 * Page size depends on machine architecture (4 kB, 8 kB, 16 kB, 64 kB...)
 */
#define KB_TO_PG(k)	((k) >> kb_shift)
#define PG_TO_KB(k)	((k) << kb_shift)

/* Type of persistent device names used in sar and iostat */
extern char persistent_name_type[MAX_FILE_LEN];
--]]

ffi.cdef[[
/*
 ***************************************************************************
 * Structures definitions
 ***************************************************************************
 */

/* Structure used for extended disk statistics */
struct ext_disk_stats {
	double util;
	double await;
	double svctm;
	double arqsz;
};
]]


-- Number of ticks per second
local  hz = 0;
-- Number of bit shifts to convert pages to kB
local  kb_shift = 0;

-- Type of persistent device names used in sar and iostat
--char persistent_name_type[MAX_FILE_LEN];

--[[
 ***************************************************************************
 * Print sysstat version number and exit.
 ***************************************************************************
--]]
local function print_version()

	printf(_("sysstat version %s\n"), VERSION);
	printf("(C) William Adams \n");
	exit(0);
end

--[[
 ***************************************************************************
 * Get local date and time.
 *
 * IN:
 * @d_off	Day offset (number of days to go back in the past).
 *
 * OUT:
 * @rectime	Current local date and time.
 *
 * RETURNS:
 * Value of time in seconds since the Epoch.
 ***************************************************************************
 --]]
local function  get_localtime(struct tm *rectime, int d_off)

	time_t timer;
	struct tm *ltm;

	time(&timer);
	timer -= SEC_PER_DAY * d_off;
	ltm = localtime(&timer);

	if (ltm) then
		*rectime = *ltm;
	end

	return timer;
end

--[[
 ***************************************************************************
 * Get date and time expressed in UTC.
 *
 * IN:
 * @d_off	Day offset (number of days to go back in the past).
 *
 * OUT:
 * @rectime	Current date and time expressed in UTC.
 *
 * RETURNS:
 * Value of time in seconds since the Epoch.
 ***************************************************************************
 --]]
local function  get_gmtime(struct tm *rectime, int d_off)

	time_t timer;
	struct tm *ltm;

	time(&timer);
	timer -= SEC_PER_DAY * d_off;
	ltm = gmtime(&timer);

	if (ltm) then
		*rectime = *ltm;
	end

	return timer;
end

--[[
 ***************************************************************************
 * Get date and time and take into account <ENV_TIME_DEFTM> variable.
 *
 * IN:
 * @d_off	Day offset (number of days to go back in the past).
 *
 * OUT:
 * @rectime	Current date and time.
 *
 * RETURNS:
 * Value of time in seconds since the Epoch.
 ***************************************************************************
 --]]
local function  get_time(struct tm *rectime, int d_off)

	static int utc = 0;
	char *e;

	if (!utc) then
		--[[ Read environment variable value once --]]
		if ((e = getenv(ENV_TIME_DEFTM)) != nil) {
			utc = !strcmp(e, K_UTC);
		}
		utc++;
	end

	if (utc == 2) then
		return get_gmtime(rectime, d_off);
	else
		return get_localtime(rectime, d_off);
	end
end

--[[
 ***************************************************************************
 * Count number of comma-separated values in arguments list. For example,
 * the number will be 3 for the list "foobar -p 1 -p 2,3,4 2 5".
 *
 * IN:
 * @arg_c	Number of arguments in the list.
 * @arg_v	Arguments list.
 *
 * RETURNS:
 * Number of comma-separated values in the list.
 ***************************************************************************
 --]]
local function  count_csvalues(int arg_c, char **arg_v)

	int opt = 1;
	int nr = 0;
	char *t;

	while (opt < arg_c) {
		if (strchr(arg_v[opt], ',')) {
			for (t = arg_v[opt]; t; t = strchr(t + 1, ',')) {
				nr++;
			}
		}
		opt++;
	}

	return nr;
end

--[[
 ***************************************************************************
 * Look for partitions of a given block device in /sys filesystem.
 *
 * IN:
 * @dev_name	Name of the block device.
 *
 * RETURNS:
 * Number of partitions for the given block device.
 ***************************************************************************
 --]]
local function  get_dev_part_nr(char *dev_name)

	DIR *dir;
	struct dirent *drd;
	char dfile[MAX_PF_NAME], line[MAX_PF_NAME];
	int part = 0;

	snprintf(dfile, MAX_PF_NAME, "%s/%s", SYSFS_BLOCK, dev_name);
	dfile[MAX_PF_NAME - 1] = '\0';

	--[[ Open current device directory in /sys/block --]]
	if ((dir = opendir(dfile)) == nil)
		return 0;

	--[[ Get current file entry --]]
	while ((drd = readdir(dir)) != nil) {
		if (!strcmp(drd.d_name, ".") or !strcmp(drd.d_name, ".."))
			continue;
		snprintf(line, MAX_PF_NAME, "%s/%s/%s", dfile, drd.d_name, S_STAT);
		line[MAX_PF_NAME - 1] = '\0';

		--[[ Try to guess if current entry is a directory containing a stat file --]]
		if (!access(line, R_OK)) {
			--[[ Yep... --]]
			part++;
		}
	}

	--[[ Close directory --]]
	closedir(dir);

	return part;
end

--[[
 ***************************************************************************
 * Look for block devices present in /sys/ filesystem:
 * Check first that sysfs is mounted (done by trying to open /sys/block
 * directory), then find number of devices registered.
 *
 * IN:
 * @display_partitions	Set to TRUE if partitions must also be counted.
 *
 * RETURNS:
 * Total number of block devices (and partitions if @display_partitions was
 * set).
 ***************************************************************************
 --]]
local function  get_sysfs_dev_nr(display_partitions)

	DIR *dir;
	struct dirent *drd;
	char line[MAX_PF_NAME];
	int dev = 0;

	--[[ Open /sys/block directory --]]
	if ((dir = opendir(SYSFS_BLOCK)) == nil)
		--[[ sysfs not mounted, or perhaps this is an old kernel --]]
		return 0;

	--[[ Get current file entry in /sys/block directory --]]
	while ((drd = readdir(dir)) != nil) {
		if (!strcmp(drd.d_name, ".") or !strcmp(drd.d_name, ".."))
			continue;
		snprintf(line, MAX_PF_NAME, "%s/%s/%s", SYSFS_BLOCK, drd.d_name, S_STAT);
		line[MAX_PF_NAME - 1] = '\0';

		--[[ Try to guess if current entry is a directory containing a stat file --]]
		if (!access(line, R_OK)) then
			--[[ Yep... --]]
			dev++;

			if (display_partitions) then
				--[[ We also want the number of partitions for this device --]]
				dev += get_dev_part_nr(drd.d_name);
			end
		end
	}

	-- Close /sys/block directory
	closedir(dir);

	return dev;
end

--[[
 ***************************************************************************
 * Read /proc/devices file and get device-mapper major number.
 * If device-mapper entry is not found in file, assume it's not active.
 *
 * RETURNS:
 * Device-mapper major number.
 ***************************************************************************
 --]]
local function  get_devmap_major(void)

	FILE *fp;
	char line[128];
	--[[
	 * Linux uses 12 bits for the major number,
	 * so this shouldn't match any real device.
	 --]]
	unsigned int dm_major = ~0U;

	if ((fp = fopen(DEVICES, "r")) == nil)
		return dm_major;

	while (fgets(line, sizeof(line), fp) != nil) {

		if (strstr(line, "device-mapper")) {
			--[[ Read device-mapper major number --]]
			sscanf(line, "%u", &dm_major);
		}
	}

	fclose(fp);

	return dm_major;
end

--[[
 ***************************************************************************
 * Print banner.
 *
 * IN:
 * @rectime	Date to display (don't use time fields).
 * @sysname	System name to display.
 * @release	System release number to display.
 * @nodename	Hostname to display.
 * @machine	Machine architecture to display.
 * @cpu_nr	Number of CPU.
 *
 * RETURNS:
 * TRUE if S_TIME_FORMAT is set to ISO, or FALSE otherwise.
 ***************************************************************************
 --]]
local function  print_gal_header(struct tm *rectime, char *sysname, char *release,
		     char *nodename, char *machine, int cpu_nr)

	char cur_date[64];
	char *e;
	int rc = 0;

	if (rectime == nil) then
		strcpy(cur_date, "?/?/?");
	
	elseif (((e = getenv(ENV_TIME_FMT)) != nil) && !strcmp(e, K_ISO)) then
		strftime(cur_date, sizeof(cur_date), "%Y-%m-%d", rectime);
		rc = 1;
	
	else 
		strftime(cur_date, sizeof(cur_date), "%x", rectime);
	end

	printf("%s %s (%s) \t%s \t_%s_\t(%d CPU)\n", sysname, release, nodename,
	       cur_date, machine, cpu_nr);

	return rc;
end

if USE_NLS then
--[[
 ***************************************************************************
 * Init National Language Support.
 ***************************************************************************
 --]]
local function init_nls(void)

	setlocale(LC_MESSAGES, "");
	setlocale(LC_CTYPE, "");
	setlocale(LC_TIME, "");
	setlocale(LC_NUMERIC, "");

	bindtextdomain(PACKAGE, LOCALEDIR);
	textdomain(PACKAGE);
end
end

--[[
 ***************************************************************************
 * Get number of rows for current window.
 *
 * RETURNS:
 * Number of rows.
 ***************************************************************************
 --]]
local function  get_win_height(void)

	struct winsize win;
	--[[
	 * This default value will be used whenever STDOUT
	 * is redirected to a pipe or a file
	 --]]
	int rows = 3600 * 24;

	if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &win) != -1) {
		if (win.ws_row > 2) {
			rows = win.ws_row - 2;
		}
	}
	return rows;
end

--[[
 ***************************************************************************
 * Canonicalize and remove /dev from path name.
 *
 * IN:
 * @name	Device name (may begin with "/dev/" or can be a symlink).
 *
 * RETURNS:
 * Device basename.
 ***************************************************************************
 --]]
local function device_name(char *name)

	static char out[MAX_FILE_LEN];
	char *resolved_name;
	int i = 0;

	--[[ realpath() creates new string, so we need to free it later --]]
	resolved_name = realpath(name, nil);

	--[[ If path doesn't exist, just return input --]]
	if (!resolved_name) {
		return name;
	}

	if (!strncmp(resolved_name, "/dev/", 5)) {
		i = 5;
	}
	strncpy(out, resolved_name + i, MAX_FILE_LEN);
	out[MAX_FILE_LEN - 1] = '\0';

	free(resolved_name);

	return out;
end

--[[
 ***************************************************************************
 * Test whether given name is a device or a partition, using sysfs.
 * This is more straightforward that using ioc_iswhole() function from
 * ioconf.c which should be used only with kernels that don't have sysfs.
 *
 * IN:
 * @name		Device or partition name.
 * @allow_virtual	TRUE if virtual devices are also accepted.
 *			The device is assumed to be virtual if no
 *			/sys/block/<device>/device link exists.
 *
 * RETURNS:
 * TRUE if @name is not a partition.
 ***************************************************************************
 --]]
local function is_device(char *name, int allow_virtual)

	char syspath[PATH_MAX];
	char *slash;

	--[[ Some devices may have a slash in their name (eg. cciss/c0d0...) --]]
	while ((slash = strchr(name, '/'))) {
		*slash = '!';
	}
	snprintf(syspath, sizeof(syspath), "%s/%s%s", SYSFS_BLOCK, name,
		 allow_virtual ? "" : "/device");

	return !(access(syspath, F_OK));
end

--[[
 ***************************************************************************
 * Get page shift in kB.
 ***************************************************************************
 --]]
local function  get_kb_shift(void)

	int shift = 0;
	long size;

	--[[ One can also use getpagesize() to get the size of a page --]]
	if ((size = sysconf(_SC_PAGESIZE)) == -1) {
		perror("sysconf");
	}

	size >>= 10;	--[[ Assume that a page has a minimum size of 1 kB --]]

	while (size > 1) {
		shift++;
		size >>= 1;
	}

	kb_shift = (unsigned int) shift;
end

--[[
 ***************************************************************************
 * Get number of clock ticks per second.
 ***************************************************************************
 --]]
local function get_HZ()

	long ticks;

	if ((ticks = sysconf(_SC_CLK_TCK)) == -1) then
		perror("sysconf");
	end

	hz = ffi.cast("unsigned int", ticks);

	return hz;
end

--[[
 ***************************************************************************
 * Workaround for CPU counters read from /proc/stat: Dyn-tick kernels
 * have a race issue that can make those counters go backward.
 ***************************************************************************
 --]]
local function  ll_sp_value(unsigned long long value1, unsigned long long value2,
		   unsigned long long itv)

	if (value2 < value1)
		return (double) 0;
	else
		return SP_VALUE(value1, value2, itv);
end

--[[
 ***************************************************************************
 * Compute time interval.
 *
 * IN:
 * @prev_uptime	Previous uptime value in jiffies.
 * @curr_uptime	Current uptime value in jiffies.
 *
 * RETURNS:
 * Interval of time in jiffies.
 ***************************************************************************
 --]]
local function  get_interval(unsigned long long prev_uptime, unsigned long long curr_uptime)

	unsigned long long itv;

	--[[ prev_time=0 when displaying stats since system startup --]]
	itv = curr_uptime - prev_uptime;

	if (!itv) then	--[[ Paranoia checking --]]
		itv = 1;
	end

	return itv;
end

--[[
 ***************************************************************************
 * Since ticks may vary slightly from CPU to CPU, we'll want
 * to recalculate itv based on this CPU's tick count, rather
 * than that reported by the "cpu" line. Otherwise we
 * occasionally end up with slightly skewed figures, with
 * the skew being greater as the time interval grows shorter.
 *
 * IN:
 * @scc	Current sample statistics for current CPU.
 * @scp	Previous sample statistics for current CPU.
 *
 * RETURNS:
 * Interval of time based on current CPU.
 ***************************************************************************
 --]]
local function  get_per_cpu_interval(struct stats_cpu *scc,
					struct stats_cpu *scp)

	unsigned long long ishift = 0LL;

	if ((scc.cpu_user - scc.cpu_guest) < (scp.cpu_user - scp.cpu_guest)) {
		--[[
		 * Sometimes the nr of jiffies spent in guest mode given by the guest
		 * counter in /proc/stat is slightly higher than that included in
		 * the user counter. Update the interval value accordingly.
		 --]]
		ishift += (scp.cpu_user - scp.cpu_guest) -
		          (scc.cpu_user - scc.cpu_guest);
	}
	if ((scc.cpu_nice - scc.cpu_guest_nice) < (scp.cpu_nice - scp.cpu_guest_nice)) {
		--[[
		 * Idem for nr of jiffies spent in guest_nice mode.
		 --]]
		ishift += (scp.cpu_nice - scp.cpu_guest_nice) -
		          (scc.cpu_nice - scc.cpu_guest_nice);
	}

	--[[
	 * Don't take cpu_guest and cpu_guest_nice into account
	 * because cpu_user and cpu_nice already include them.
	 --]]
	return ((scc.cpu_user    + scc.cpu_nice   +
		 scc.cpu_sys     + scc.cpu_iowait +
		 scc.cpu_idle    + scc.cpu_steal  +
		 scc.cpu_hardirq + scc.cpu_softirq) -
		(scp.cpu_user    + scp.cpu_nice   +
		 scp.cpu_sys     + scp.cpu_iowait +
		 scp.cpu_idle    + scp.cpu_steal  +
		 scp.cpu_hardirq + scp.cpu_softirq) +
		 ishift);
end

--[[
 ***************************************************************************
 * Unhandled situation: Panic and exit. Should never happen.
 *
 * IN:
 * @function	Function name where situation occured.
 * @error_code	Error code.
 ***************************************************************************
 --]]
local function  sysstat_panic(const char *function, int error_code)

	fprintf(stderr, "sysstat: %s[%d]: Internal error...\n",
		function, error_code);
	exit(1);
end

--[[
 ***************************************************************************
 * Count number of bits set in an array.
 *
 * IN:
 * @ptr		Pointer to array.
 * @size	Size of array in bytes.
 *
 * RETURNS:
 * Number of bits set in the array.
 ***************************************************************************
--]]
local function  count_bits(void *ptr, int size)

	local nr = 0

	local p = ptr;
	local i = 0;
	while (i < size; i++, p++) do
		local k = 0x80;
		while (k > 0) do
			if (*p & k) then
				nr++;
			end
			k = rshift(k, 1);
		end
	end

	return nr;
end

--[[
 ***************************************************************************
 * Compute "extended" device statistics (service time, etc.).
 *
 * IN:
 * @sdc		Structure with current device statistics.
 * @sdp		Structure with previous device statistics.
 * @itv		Interval of time in jiffies.
 *
 * OUT:
 * @xds		Structure with extended statistics.
 ***************************************************************************
--]]
local function  compute_ext_disk_stats(struct stats_disk *sdc, struct stats_disk *sdp,
			    unsigned long long itv, struct ext_disk_stats *xds)

	double tput
		= ((double) (sdc.nr_ios - sdp.nr_ios)) * HZ / itv;

	xds.util  = S_VALUE(sdp.tot_ticks, sdc.tot_ticks, itv);
	xds.svctm = tput ? xds.util / tput : 0.0;
	--[[
	 * Kernel gives ticks already in milliseconds for all platforms
	 * => no need for further scaling.
	 --]]
	xds.await = (sdc.nr_ios - sdp.nr_ios) ?
		((sdc.rd_ticks - sdp.rd_ticks) + (sdc.wr_ticks - sdp.wr_ticks)) /
		((double) (sdc.nr_ios - sdp.nr_ios)) : 0.0;
	xds.arqsz = (sdc.nr_ios - sdp.nr_ios) ?
		((sdc.rd_sect - sdp.rd_sect) + (sdc.wr_sect - sdp.wr_sect)) /
		((double) (sdc.nr_ios - sdp.nr_ios)) : 0.0;
end

--[[
 ***************************************************************************
 * Convert in-place input string to lowercase.
 *
 * IN:
 * @str		String to be converted.
 *
 * OUT:
 * @str		String in lowercase.
 *
 * RETURNS:
 * String in lowercase.
 ***************************************************************************
--]]
-- TODO, this will not alter the passed in string
local function strtolower(str)
	return string.lower(str);
--[[	
	char *cp = str;

	while (*cp) do
		*cp = tolower(*cp);
		cp++;
	end

	return(str);
--]]
end

--[[
 ***************************************************************************
 * Get persistent type name directory from type.
 *
 * IN:
 * @type	Persistent type name (UUID, LABEL, etc.)
 *
 * RETURNS:
 * Path to the persistent type name directory, or nil if access is denied.
 ***************************************************************************
--]]
local function get_persistent_type_dir(char *type)

	static char dir[32];

	snprintf(dir, 32, "%s-%s", DEV_DISK_BY, type);

	if (access(dir, R_OK)) {
		return (nil);
	}

	return (dir);
end

--[[
 ***************************************************************************
 * Get persistent name absolute path.
 *
 * IN:
 * @name	Persistent name.
 *
 * RETURNS:
 * Path to the persistent name, or nil if file doesn't exist.
 ***************************************************************************
--]]
local function get_persistent_name_path(char *name)

	static char path[PATH_MAX];

	snprintf(path, PATH_MAX, "%s/%s",
		 get_persistent_type_dir(persistent_name_type), name);

	if (access(path, F_OK)) then
		return (nil);
	end

	return (path);
end

--[[
 ***************************************************************************
 * Get files from persistent type name directory.
 *
 * RETURNS:
 * List of files in the persistent type name directory in alphabetical order.
 ***************************************************************************
--]]
local function get_persistent_names()

	int n, i, k = 0;
	char *dir;
	char **files = nil;
	struct dirent **namelist;

	--[[ Get directory name for selected persistent type --]]
	dir = get_persistent_type_dir(persistent_name_type);
	if (!dir) then
		return (nil);
	end

	n = scandir(dir, &namelist, nil, alphasort);
	if (n < 0) then
		return (nil);
	end

	--[[ If directory is empty, it contains 2 entries: "." and ".." --]]
	if (n <= 2)
		--[[ Free list and return nil --]]
		goto free_list;

	--[[ Ignore the "." and "..", but keep place for one last nil. --]]
	files = (char **) calloc(n - 1, sizeof(char *));
	if (!files)
		goto free_list;

	--[[
	 * i is for traversing namelist, k is for files.
	 * i != k because we are ignoring "." and ".." entries.
	 --]]
	for (i = 0; i < n; i++) {
		--[[ Ignore "." and "..". --]]
		if (!strcmp(".", namelist[i].d_name) or
		    !strcmp("..", namelist[i].d_name))
			continue;

		files[k] = (char *) calloc(strlen(namelist[i].d_name) + 1, sizeof(char));
		if (!files[k])
			continue;

		strcpy(files[k++], namelist[i].d_name);
	}
	files[k] = nil;

free_list:

	for (i = 0; i < n; i++) {
		free(namelist[i]);
	}
	free(namelist);

	return (files);
end

--[[
 ***************************************************************************
 * Get persistent name from pretty name.
 *
 * IN:
 * @pretty	Pretty name (e.g. sda, sda1, ..).
 *
 * RETURNS:
 * Persistent name.
 ***************************************************************************
--]]
local function get_persistent_name_from_pretty(char *pretty)

	int i = -1;
	ssize_t r;
	char *link, *name;
	char **persist_names;
	char target[PATH_MAX];
	static char persist_name[FILENAME_MAX];

	persist_name[0] = '\0';

	--[[ Get list of files from persistent type name directory --]]
	persist_names = get_persistent_names();
	if (!persist_names)
		return (nil);

	while (persist_names[++i]) {
		--[[ Get absolute path for current persistent name --]]
		link = get_persistent_name_path(persist_names[i]);
		if (!link)
			continue;

		--[[ Persistent name is usually a symlink: Read it... --]]
		r = readlink(link, target, PATH_MAX);
		if ((r <= 0) or (r >= PATH_MAX))
			continue;

		target[r] = '\0';

		--[[ ... and get device pretty name it points at --]]
		name = basename(target);
		if (!name or (name[0] == '\0'))
			continue;

		if (!strncmp(name, pretty, FILENAME_MAX)) {
			--[[ We have found pretty name for current persistent one --]]
			strncpy(persist_name, persist_names[i], FILENAME_MAX);
			persist_name[FILENAME_MAX - 1] = '\0';
			break;
		}
	}

	i = -1;
	while (persist_names[++i]) {
		free (persist_names[i]);
	}
	free (persist_names);

	if (strlen(persist_name) <= 0)
		return (nil);

	return persist_name;
end

--[[
 ***************************************************************************
 * Get pretty name (sda, sda1...) from persistent name.
 *
 * IN:
 * @persistent	Persistent name.
 *
 * RETURNS:
 * Pretty name.
 ***************************************************************************
--]]
local function get_pretty_name_from_persistent(char *persistent)

	ssize_t r;
	char *link, *pretty, target[PATH_MAX];

	--[[ Get absolute path for persistent name --]]
	link = get_persistent_name_path(persistent);
	if (!link)
		return (nil);

	--[[ Persistent name is usually a symlink: Read it... --]]
	r = readlink(link, target, PATH_MAX);
	if ((r <= 0) or (r >= PATH_MAX)) then
		return nil;
	end

	target[r] = '\0';

	--[[ ... and get device pretty name it points at --]]
	pretty = basename(target);
	if (!pretty or (pretty[0] == '\0')) then
		return (nil);
	end

	return pretty;
end

local exports = {
	compute_ext_disk_stats=compute_ext_disk_stats;
	count_bits=count_bits;
	count_csvalues=count_csvalues;
	device_name=device_name;
	get_HZ=get_HZ;
	get_devmap_major=get_devmap_major;
	get_interval=get_interval;
	get_kb_shift=get_kb_shift;
	get_localtime=get_localtime;
	get_time=get_time;
	get_per_cpu_interval=get_per_cpu_interval;
	get_persistent_name_from_pretty=get_persistent_name_from_pretty;
	get_persistent_type_dir=get_persistent_type_dir;
	get_pretty_name_from_persistent=get_pretty_name_from_persistent;
	get_sysfs_dev_nr=get_sysfs_dev_nr;
	get_win_height=get_win_height;
	init_nls=init_nls;
	is_device=is_device;
	ll_sp_value=ll_sp_value;
	print_gal_header=print_gal_header;
	print_version=print_version;
	strtolower=strtolower;
	sysstat_panic=sysstat_panic;
}

return exports
