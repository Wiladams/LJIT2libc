--[[
/*
 * rd_stats.h: Include file used to read system statistics
 * (C) 1999-2015 by Sebastien Godard (sysstat <at> orange.fr)
 */
--]]

local ffi = require("ffi")


ffi.cdef[[
static const int IFNAMSIZ =	16;
// Maximum length of network interface name 
static const int MAX_IFACE_LEN	= IFNAMSIZ;
// Maximum length of USB manufacturer string 
static const int	MAX_MANUF_LEN	= 24;
// Maximum length of USB product string 
static const int	MAX_PROD_LEN	= 48;
// Maximum length of filesystem name 
static const int	MAX_FS_LEN	= 128;
// Maximum length of FC host name 
static const int	MAX_FCH_LEN	= 16;
]]

--[[
 ***************************************************************************
 * Definitions of structures for system statistics
 ***************************************************************************
--]]

ffi.cdef[[
/*
 * Structure for CPU statistics.
 * In activity buffer: First structure is for global CPU utilisation ("all").
 * Following structures are for each individual CPU (0, 1, etc.)
 */
struct stats_cpu {
	unsigned long long cpu_user		__attribute__ ((aligned (16)));
	unsigned long long cpu_nice		__attribute__ ((aligned (16)));
	unsigned long long cpu_sys		__attribute__ ((aligned (16)));
	unsigned long long cpu_idle		__attribute__ ((aligned (16)));
	unsigned long long cpu_iowait		__attribute__ ((aligned (16)));
	unsigned long long cpu_steal		__attribute__ ((aligned (16)));
	unsigned long long cpu_hardirq		__attribute__ ((aligned (16)));
	unsigned long long cpu_softirq		__attribute__ ((aligned (16)));
	unsigned long long cpu_guest		__attribute__ ((aligned (16)));
	unsigned long long cpu_guest_nice	__attribute__ ((aligned (16)));
};
]]


ffi.cdef[[
/*
 * Structure for task creation and context switch statistics.
 * The attribute (aligned(16)) is necessary so that sizeof(structure) has
 * the same value on 32 and 64-bit architectures.
 */
struct stats_pcsw {
	unsigned long long context_switch	__attribute__ ((aligned (16)));
	unsigned long processes			__attribute__ ((aligned (16)));
};
]]


ffi.cdef[[
/*
 * Structure for interrupts statistics.
 * In activity buffer: First structure is for total number of interrupts ("SUM").
 * Following structures are for each individual interrupt (0, 1, etc.)
 *
 * NOTE: The total number of interrupts is saved as a %llu by the kernel,
 * whereas individual interrupts are saved as %u.
 */
struct stats_irq {
	unsigned long long irq_nr	__attribute__ ((aligned (16)));
};
]]


ffi.cdef[[
/* Structure for swapping statistics */
struct stats_swap {
	unsigned long pswpin	__attribute__ ((aligned (8)));
	unsigned long pswpout	__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for paging statistics */
struct stats_paging {
	unsigned long pgpgin		__attribute__ ((aligned (8)));
	unsigned long pgpgout		__attribute__ ((aligned (8)));
	unsigned long pgfault		__attribute__ ((aligned (8)));
	unsigned long pgmajfault	__attribute__ ((aligned (8)));
	unsigned long pgfree		__attribute__ ((aligned (8)));
	unsigned long pgscan_kswapd	__attribute__ ((aligned (8)));
	unsigned long pgscan_direct	__attribute__ ((aligned (8)));
	unsigned long pgsteal		__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for I/O and transfer rate statistics */
struct stats_io {
	unsigned long long dk_drive		__attribute__ ((aligned (16)));
	unsigned long long dk_drive_rio		__attribute__ ((packed));
	unsigned long long dk_drive_wio		__attribute__ ((packed));
	unsigned long long dk_drive_rblk	__attribute__ ((packed));
	unsigned long long dk_drive_wblk	__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for memory and swap space utilization statistics */
struct stats_memory {
	unsigned long frmkb	__attribute__ ((aligned (8)));
	unsigned long bufkb	__attribute__ ((aligned (8)));
	unsigned long camkb	__attribute__ ((aligned (8)));
	unsigned long tlmkb	__attribute__ ((aligned (8)));
	unsigned long frskb	__attribute__ ((aligned (8)));
	unsigned long tlskb	__attribute__ ((aligned (8)));
	unsigned long caskb	__attribute__ ((aligned (8)));
	unsigned long comkb	__attribute__ ((aligned (8)));
	unsigned long activekb	__attribute__ ((aligned (8)));
	unsigned long inactkb	__attribute__ ((aligned (8)));
	unsigned long dirtykb	__attribute__ ((aligned (8)));
	unsigned long anonpgkb	__attribute__ ((aligned (8)));
	unsigned long slabkb	__attribute__ ((aligned (8)));
	unsigned long kstackkb	__attribute__ ((aligned (8)));
	unsigned long pgtblkb	__attribute__ ((aligned (8)));
	unsigned long vmusedkb	__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for kernel tables statistics */
struct stats_ktables {
	unsigned int  file_used		__attribute__ ((aligned (4)));
	unsigned int  inode_used	__attribute__ ((packed));
	unsigned int  dentry_stat	__attribute__ ((packed));
	unsigned int  pty_nr		__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for queue and load statistics */
struct stats_queue {
	unsigned long nr_running	__attribute__ ((aligned (8)));
	unsigned long procs_blocked	__attribute__ ((aligned (8)));
	unsigned int  load_avg_1	__attribute__ ((aligned (8)));
	unsigned int  load_avg_5	__attribute__ ((packed));
	unsigned int  load_avg_15	__attribute__ ((packed));
	unsigned int  nr_threads	__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for serial statistics */
struct stats_serial {
	unsigned int rx		__attribute__ ((aligned (4)));
	unsigned int tx		__attribute__ ((packed));
	unsigned int frame	__attribute__ ((packed));
	unsigned int parity	__attribute__ ((packed));
	unsigned int brk	__attribute__ ((packed));
	unsigned int overrun	__attribute__ ((packed));
	/*
	 * A value of 0 means that the structure is unused.
	 * To avoid the confusion, the line number is saved as (line# + 1)
	 */
	unsigned int line	__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for block devices statistics */
struct stats_disk {
	unsigned long long nr_ios	__attribute__ ((aligned (16)));
	unsigned long rd_sect		__attribute__ ((aligned (16)));
	unsigned long wr_sect		__attribute__ ((aligned (8)));
	unsigned int rd_ticks		__attribute__ ((aligned (8)));
	unsigned int wr_ticks		__attribute__ ((packed));
	unsigned int tot_ticks		__attribute__ ((packed));
	unsigned int rq_ticks		__attribute__ ((packed));
	unsigned int major		__attribute__ ((packed));
	unsigned int minor		__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for network interfaces statistics */
struct stats_net_dev {
	unsigned long long rx_packets		__attribute__ ((aligned (16)));
	unsigned long long tx_packets		__attribute__ ((aligned (16)));
	unsigned long long rx_bytes		__attribute__ ((aligned (16)));
	unsigned long long tx_bytes		__attribute__ ((aligned (16)));
	unsigned long long rx_compressed	__attribute__ ((aligned (16)));
	unsigned long long tx_compressed	__attribute__ ((aligned (16)));
	unsigned long long multicast		__attribute__ ((aligned (16)));
	unsigned int       speed		__attribute__ ((aligned (16)));
	char 	 interface[MAX_IFACE_LEN]	__attribute__ ((aligned (4)));
	char	 duplex;
};
]]


ffi.cdef[[
/* Structure for network interface errors statistics */
struct stats_net_edev {
	unsigned long long collisions		__attribute__ ((aligned (16)));
	unsigned long long rx_errors		__attribute__ ((aligned (16)));
	unsigned long long tx_errors		__attribute__ ((aligned (16)));
	unsigned long long rx_dropped		__attribute__ ((aligned (16)));
	unsigned long long tx_dropped		__attribute__ ((aligned (16)));
	unsigned long long rx_fifo_errors	__attribute__ ((aligned (16)));
	unsigned long long tx_fifo_errors	__attribute__ ((aligned (16)));
	unsigned long long rx_frame_errors	__attribute__ ((aligned (16)));
	unsigned long long tx_carrier_errors	__attribute__ ((aligned (16)));
	char	      interface[MAX_IFACE_LEN]	__attribute__ ((aligned (16)));
};
]]


ffi.cdef[[
/* Structure for NFS client statistics */
struct stats_net_nfs {
	unsigned int  nfs_rpccnt	__attribute__ ((aligned (4)));
	unsigned int  nfs_rpcretrans	__attribute__ ((packed));
	unsigned int  nfs_readcnt	__attribute__ ((packed));
	unsigned int  nfs_writecnt	__attribute__ ((packed));
	unsigned int  nfs_accesscnt	__attribute__ ((packed));
	unsigned int  nfs_getattcnt	__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for NFS server statistics */
struct stats_net_nfsd {
	unsigned int  nfsd_rpccnt	__attribute__ ((aligned (4)));
	unsigned int  nfsd_rpcbad	__attribute__ ((packed));
	unsigned int  nfsd_netcnt	__attribute__ ((packed));
	unsigned int  nfsd_netudpcnt	__attribute__ ((packed));
	unsigned int  nfsd_nettcpcnt	__attribute__ ((packed));
	unsigned int  nfsd_rchits	__attribute__ ((packed));
	unsigned int  nfsd_rcmisses	__attribute__ ((packed));
	unsigned int  nfsd_readcnt	__attribute__ ((packed));
	unsigned int  nfsd_writecnt	__attribute__ ((packed));
	unsigned int  nfsd_accesscnt	__attribute__ ((packed));
	unsigned int  nfsd_getattcnt	__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for IPv4 sockets statistics */
struct stats_net_sock {
	unsigned int  sock_inuse	__attribute__ ((aligned (4)));
	unsigned int  tcp_inuse		__attribute__ ((packed));
	unsigned int  tcp_tw		__attribute__ ((packed));
	unsigned int  udp_inuse		__attribute__ ((packed));
	unsigned int  raw_inuse		__attribute__ ((packed));
	unsigned int  frag_inuse	__attribute__ ((packed));
};
]]


ffi.cdef[[
/* Structure for IP statistics */
struct stats_net_ip {
	unsigned long long InReceives		__attribute__ ((aligned (16)));
	unsigned long long ForwDatagrams	__attribute__ ((aligned (16)));
	unsigned long long InDelivers		__attribute__ ((aligned (16)));
	unsigned long long OutRequests		__attribute__ ((aligned (16)));
	unsigned long long ReasmReqds		__attribute__ ((aligned (16)));
	unsigned long long ReasmOKs		__attribute__ ((aligned (16)));
	unsigned long long FragOKs		__attribute__ ((aligned (16)));
	unsigned long long FragCreates		__attribute__ ((aligned (16)));
};
]]



ffi.cdef[[
/* Structure for IP errors statistics */
struct stats_net_eip {
	unsigned long long InHdrErrors		__attribute__ ((aligned (16)));
	unsigned long long InAddrErrors		__attribute__ ((aligned (16)));
	unsigned long long InUnknownProtos	__attribute__ ((aligned (16)));
	unsigned long long InDiscards		__attribute__ ((aligned (16)));
	unsigned long long OutDiscards		__attribute__ ((aligned (16)));
	unsigned long long OutNoRoutes		__attribute__ ((aligned (16)));
	unsigned long long ReasmFails		__attribute__ ((aligned (16)));
	unsigned long long FragFails		__attribute__ ((aligned (16)));
};
]]



ffi.cdef[[
/* Structure for ICMP statistics */
struct stats_net_icmp {
	unsigned long InMsgs		__attribute__ ((aligned (8)));
	unsigned long OutMsgs		__attribute__ ((aligned (8)));
	unsigned long InEchos		__attribute__ ((aligned (8)));
	unsigned long InEchoReps	__attribute__ ((aligned (8)));
	unsigned long OutEchos		__attribute__ ((aligned (8)));
	unsigned long OutEchoReps	__attribute__ ((aligned (8)));
	unsigned long InTimestamps	__attribute__ ((aligned (8)));
	unsigned long InTimestampReps	__attribute__ ((aligned (8)));
	unsigned long OutTimestamps	__attribute__ ((aligned (8)));
	unsigned long OutTimestampReps	__attribute__ ((aligned (8)));
	unsigned long InAddrMasks	__attribute__ ((aligned (8)));
	unsigned long InAddrMaskReps	__attribute__ ((aligned (8)));
	unsigned long OutAddrMasks	__attribute__ ((aligned (8)));
	unsigned long OutAddrMaskReps	__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for ICMP error message statistics */
struct stats_net_eicmp {
	unsigned long InErrors		__attribute__ ((aligned (8)));
	unsigned long OutErrors		__attribute__ ((aligned (8)));
	unsigned long InDestUnreachs	__attribute__ ((aligned (8)));
	unsigned long OutDestUnreachs	__attribute__ ((aligned (8)));
	unsigned long InTimeExcds	__attribute__ ((aligned (8)));
	unsigned long OutTimeExcds	__attribute__ ((aligned (8)));
	unsigned long InParmProbs	__attribute__ ((aligned (8)));
	unsigned long OutParmProbs	__attribute__ ((aligned (8)));
	unsigned long InSrcQuenchs	__attribute__ ((aligned (8)));
	unsigned long OutSrcQuenchs	__attribute__ ((aligned (8)));
	unsigned long InRedirects	__attribute__ ((aligned (8)));
	unsigned long OutRedirects	__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for TCP statistics */
struct stats_net_tcp {
	unsigned long ActiveOpens	__attribute__ ((aligned (8)));
	unsigned long PassiveOpens	__attribute__ ((aligned (8)));
	unsigned long InSegs		__attribute__ ((aligned (8)));
	unsigned long OutSegs		__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for TCP errors statistics */
struct stats_net_etcp {
	unsigned long AttemptFails	__attribute__ ((aligned (8)));
	unsigned long EstabResets	__attribute__ ((aligned (8)));
	unsigned long RetransSegs	__attribute__ ((aligned (8)));
	unsigned long InErrs		__attribute__ ((aligned (8)));
	unsigned long OutRsts		__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for UDP statistics */
struct stats_net_udp {
	unsigned long InDatagrams	__attribute__ ((aligned (8)));
	unsigned long OutDatagrams	__attribute__ ((aligned (8)));
	unsigned long NoPorts		__attribute__ ((aligned (8)));
	unsigned long InErrors		__attribute__ ((aligned (8)));
};
]]


ffi.cdef[[
/* Structure for IPv6 statistics */
struct stats_net_ip6 {
	unsigned long long InReceives6		__attribute__ ((aligned (16)));
	unsigned long long OutForwDatagrams6	__attribute__ ((aligned (16)));
	unsigned long long InDelivers6		__attribute__ ((aligned (16)));
	unsigned long long OutRequests6		__attribute__ ((aligned (16)));
	unsigned long long ReasmReqds6		__attribute__ ((aligned (16)));
	unsigned long long ReasmOKs6		__attribute__ ((aligned (16)));
	unsigned long long InMcastPkts6		__attribute__ ((aligned (16)));
	unsigned long long OutMcastPkts6	__attribute__ ((aligned (16)));
	unsigned long long FragOKs6		__attribute__ ((aligned (16)));
	unsigned long long FragCreates6		__attribute__ ((aligned (16)));
};
]]


ffi.cdef[[
/* Structure for IPv6 errors statistics */
struct stats_net_eip6 {
	unsigned long long InHdrErrors6		__attribute__ ((aligned (16)));
	unsigned long long InAddrErrors6	__attribute__ ((aligned (16)));
	unsigned long long InUnknownProtos6	__attribute__ ((aligned (16)));
	unsigned long long InTooBigErrors6	__attribute__ ((aligned (16)));
	unsigned long long InDiscards6		__attribute__ ((aligned (16)));
	unsigned long long OutDiscards6		__attribute__ ((aligned (16)));
	unsigned long long InNoRoutes6		__attribute__ ((aligned (16)));
	unsigned long long OutNoRoutes6		__attribute__ ((aligned (16)));
	unsigned long long ReasmFails6		__attribute__ ((aligned (16)));
	unsigned long long FragFails6		__attribute__ ((aligned (16)));
	unsigned long long InTruncatedPkts6	__attribute__ ((aligned (16)));
};
]]

ffi.cdef[[
/* Structure for ICMPv6 statistics */
struct stats_net_icmp6 {
	unsigned long InMsgs6				__attribute__ ((aligned (8)));
	unsigned long OutMsgs6				__attribute__ ((aligned (8)));
	unsigned long InEchos6				__attribute__ ((aligned (8)));
	unsigned long InEchoReplies6			__attribute__ ((aligned (8)));
	unsigned long OutEchoReplies6			__attribute__ ((aligned (8)));
	unsigned long InGroupMembQueries6		__attribute__ ((aligned (8)));
	unsigned long InGroupMembResponses6		__attribute__ ((aligned (8)));
	unsigned long OutGroupMembResponses6		__attribute__ ((aligned (8)));
	unsigned long InGroupMembReductions6		__attribute__ ((aligned (8)));
	unsigned long OutGroupMembReductions6		__attribute__ ((aligned (8)));
	unsigned long InRouterSolicits6			__attribute__ ((aligned (8)));
	unsigned long OutRouterSolicits6		__attribute__ ((aligned (8)));
	unsigned long InRouterAdvertisements6		__attribute__ ((aligned (8)));
	unsigned long InNeighborSolicits6		__attribute__ ((aligned (8)));
	unsigned long OutNeighborSolicits6		__attribute__ ((aligned (8)));
	unsigned long InNeighborAdvertisements6		__attribute__ ((aligned (8)));
	unsigned long OutNeighborAdvertisements6	__attribute__ ((aligned (8)));
};
]]

ffi.cdef[[
/* Structure for ICMPv6 error message statistics */
struct stats_net_eicmp6 {
	unsigned long InErrors6		__attribute__ ((aligned (8)));
	unsigned long InDestUnreachs6	__attribute__ ((aligned (8)));
	unsigned long OutDestUnreachs6	__attribute__ ((aligned (8)));
	unsigned long InTimeExcds6	__attribute__ ((aligned (8)));
	unsigned long OutTimeExcds6	__attribute__ ((aligned (8)));
	unsigned long InParmProblems6	__attribute__ ((aligned (8)));
	unsigned long OutParmProblems6	__attribute__ ((aligned (8)));
	unsigned long InRedirects6	__attribute__ ((aligned (8)));
	unsigned long OutRedirects6	__attribute__ ((aligned (8)));
	unsigned long InPktTooBigs6	__attribute__ ((aligned (8)));
	unsigned long OutPktTooBigs6	__attribute__ ((aligned (8)));
};


/* Structure for UDPv6 statistics */
struct stats_net_udp6 {
	unsigned long InDatagrams6	__attribute__ ((aligned (8)));
	unsigned long OutDatagrams6	__attribute__ ((aligned (8)));
	unsigned long NoPorts6		__attribute__ ((aligned (8)));
	unsigned long InErrors6		__attribute__ ((aligned (8)));
};


/* Structure for IPv6 sockets statistics */
struct stats_net_sock6 {
	unsigned int  tcp6_inuse	__attribute__ ((aligned (4)));
	unsigned int  udp6_inuse	__attribute__ ((packed));
	unsigned int  raw6_inuse	__attribute__ ((packed));
	unsigned int  frag6_inuse	__attribute__ ((packed));
};


/*
 * Structure for CPU frequency statistics.
 * In activity buffer: First structure is for global CPU utilisation ("all").
 * Following structures are for each individual CPU (0, 1, etc.)
 */
struct stats_pwr_cpufreq {
	unsigned long cpufreq	__attribute__ ((aligned (8)));
};


/* Structure for hugepages statistics */
struct stats_huge {
	unsigned long frhkb			__attribute__ ((aligned (8)));
	unsigned long tlhkb			__attribute__ ((aligned (8)));
};


/*
 * Structure for weighted CPU frequency statistics.
 * In activity buffer: First structure is for global CPU utilisation ("all").
 * Following structures are for each individual CPU (0, 1, etc.)
 */
struct stats_pwr_wghfreq {
	unsigned long long 	time_in_state	__attribute__ ((aligned (16)));
	unsigned long 		freq		__attribute__ ((aligned (16)));
};


/*
 * Structure for USB devices plugged into the system.
 */
struct stats_pwr_usb {
	unsigned int  bus_nr				__attribute__ ((aligned (4)));
	unsigned int  vendor_id				__attribute__ ((packed));
	unsigned int  product_id			__attribute__ ((packed));
	unsigned int  bmaxpower				__attribute__ ((packed));
	char	      manufacturer[MAX_MANUF_LEN];
	char	      product[MAX_PROD_LEN];
};


/* Structure for filesystems statistics */
struct stats_filesystem {
	unsigned long long f_blocks		__attribute__ ((aligned (16)));
	unsigned long long f_bfree		__attribute__ ((aligned (16)));
	unsigned long long f_bavail		__attribute__ ((aligned (16)));
	unsigned long long f_files		__attribute__ ((aligned (16)));
	unsigned long long f_ffree		__attribute__ ((aligned (16)));
	char 		   fs_name[MAX_FS_LEN]	__attribute__ ((aligned (16)));
	char 		   mountp[MAX_FS_LEN];
};


/* Structure for Fibre Channel HBA statistics */
struct stats_fchost {
	unsigned long f_rxframes		__attribute__ ((aligned (8)));
	unsigned long f_txframes		__attribute__ ((aligned (8)));
	unsigned long f_rxwords			__attribute__ ((aligned (8)));
	unsigned long f_txwords			__attribute__ ((aligned (8)));
	char	      fchost_name[MAX_FCH_LEN]	__attribute__ ((aligned (8)));
};
]]

ffi.cdef[[

/*
 ***************************************************************************
 * Prototypes for functions used to read system statistics
 ***************************************************************************
 */

 extern void
	read_stat_cpu(struct stats_cpu *, int,
		      unsigned long long *, unsigned long long *);
extern void
	read_stat_irq(struct stats_irq *, int);
extern void
	read_meminfo(struct stats_memory *);
extern void
	read_uptime(unsigned long long *);

extern void
	oct2chr(char *);
extern void
	read_stat_pcsw(struct stats_pcsw *);
extern void
	read_loadavg(struct stats_queue *);
extern void
	read_vmstat_swap(struct stats_swap *);
extern void
	read_vmstat_paging(struct stats_paging *);
extern void
	read_diskstats_io(struct stats_io *);
extern void
	read_diskstats_disk(struct stats_disk *, int, int);
extern void
	read_tty_driver_serial(struct stats_serial *, int);
extern void
	read_kernel_tables(struct stats_ktables *);
extern int
	read_net_dev(struct stats_net_dev *, int);
extern void
	read_if_info(struct stats_net_dev *, int);
extern void
	read_net_edev(struct stats_net_edev *, int);
extern void
	read_net_nfs(struct stats_net_nfs *);
extern void
	read_net_nfsd(struct stats_net_nfsd *);
extern void
	read_net_sock(struct stats_net_sock *);
extern void
	read_net_ip(struct stats_net_ip *);
extern void
	read_net_eip(struct stats_net_eip *);
extern void
	read_net_icmp(struct stats_net_icmp *);
extern void
	read_net_eicmp(struct stats_net_eicmp *);
extern void
	read_net_tcp(struct stats_net_tcp *);
extern void
	read_net_etcp(struct stats_net_etcp *);
extern void
	read_net_udp(struct stats_net_udp *);
extern void
	read_net_sock6(struct stats_net_sock6 *);
extern void
	read_net_ip6(struct stats_net_ip6 *);
extern void
	read_net_eip6(struct stats_net_eip6 *);
extern void
	read_net_icmp6(struct stats_net_icmp6 *);
extern void
	read_net_eicmp6(struct stats_net_eicmp6 *);
extern void
	read_net_udp6(struct stats_net_udp6 *);
extern void
	read_cpuinfo(struct stats_pwr_cpufreq *, int);
extern void
	read_meminfo_huge(struct stats_huge *);
extern void
	read_time_in_state(struct stats_pwr_wghfreq *, int, int);
extern void
	read_bus_usb_dev(struct stats_pwr_usb *, int);
extern void
	read_filesystem(struct stats_filesystem *, int);
extern void
	read_fchost(struct stats_fchost *, int);
]]

-- Get IFNAMSIZ
--require("net/if")


local Constants = {

	CNT_PART	= 1;
	CNT_ALL_DEV	= 0;
	CNT_USED_DEV	= 1;

	K_DUPLEX_HALF	= "half";
	K_DUPLEX_FULL	= "full";

	C_DUPLEX_HALF	= 1;
	C_DUPLEX_FULL	= 2;

--[[
 ***************************************************************************
 * System files containing statistics
 ***************************************************************************
--]]

-- Files
	PROC			= "/proc";
	SERIAL			= "/proc/tty/driver/serial";
	FDENTRY_STATE	= "/proc/sys/fs/dentry-state";
	FFILE_NR		= "/proc/sys/fs/file-nr";
	FINODE_STATE	= "/proc/sys/fs/inode-state";
	PTY_NR			= "/proc/sys/kernel/pty/nr";
	NET_DEV			= "/proc/net/dev";
	NET_SOCKSTAT	= "/proc/net/sockstat";
	NET_SOCKSTAT6	= "/proc/net/sockstat6";
	NET_RPC_NFS		= "/proc/net/rpc/nfs";
	NET_RPC_NFSD	= "/proc/net/rpc/nfsd";
	LOADAVG			= "/proc/loadavg";
	VMSTAT			= "/proc/vmstat";
	NET_SNMP		= "/proc/net/snmp";
	NET_SNMP6		= "/proc/net/snmp6";
	CPUINFO			= "/proc/cpuinfo";
	MTAB			= "/etc/mtab";
	IF_DUPLEX		= "/sys/class/net/%s/duplex";
	IF_SPEED		= "/sys/class/net/%s/speed";
	FC_RX_FRAMES	= "%s/%s/statistics/rx_frames";
	FC_TX_FRAMES	= "%s/%s/statistics/tx_frames";
	FC_RX_WORDS		= "%s/%s/statistics/rx_words";
	FC_TX_WORDS		= "%s/%s/statistics/tx_words";


	STATS_CPU_SIZE	= ffi.sizeof("struct stats_cpu");
	STATS_PCSW_SIZE	= ffi.sizeof("struct stats_pcsw");
	STATS_IRQ_SIZE	= ffi.sizeof("struct stats_irq");
	STATS_SWAP_SIZE	= ffi.sizeof("struct stats_swap");
	STATS_PAGING_SIZE	= ffi.sizeof("struct stats_paging");
	STATS_IO_SIZE	= ffi.sizeof("struct stats_io");

	STATS_MEMORY_SIZE	= ffi.sizeof("struct stats_memory");
	STATS_KTABLES_SIZE	= ffi.sizeof("struct stats_ktables");
	STATS_QUEUE_SIZE	= ffi.sizeof("struct stats_queue");
	STATS_SERIAL_SIZE	= ffi.sizeof("struct stats_serial");
	STATS_DISK_SIZE	= ffi.sizeof("struct stats_disk");
	STATS_NET_DEV_SIZE	= ffi.sizeof("struct stats_net_dev");

	STATS_NET_EDEV_SIZE	= ffi.sizeof("struct stats_net_edev");
	STATS_NET_NFS_SIZE	= ffi.sizeof("struct stats_net_nfs");
	STATS_NET_NFSD_SIZE	= ffi.sizeof("struct stats_net_nfsd");
	STATS_NET_SOCK_SIZE	= ffi.sizeof("struct stats_net_sock");
	STATS_NET_IP_SIZE	= ffi.sizeof("struct stats_net_ip");
	STATS_NET_EIP_SIZE	= ffi.sizeof("struct stats_net_eip");

	STATS_NET_ICMP_SIZE	= ffi.sizeof("struct stats_net_icmp");
	STATS_NET_EICMP_SIZE	= ffi.sizeof("struct stats_net_eicmp");
	STATS_NET_TCP_SIZE	= ffi.sizeof("struct stats_net_tcp");
	STATS_NET_ETCP_SIZE	= ffi.sizeof("struct stats_net_etcp");
	STATS_NET_UDP_SIZE	= ffi.sizeof("struct stats_net_udp");
	STATS_NET_IP6_SIZE	= ffi.sizeof("struct stats_net_ip6");
	STATS_NET_EIP6_SIZE	= ffi.sizeof("struct stats_net_eip6");
	STATS_NET_ICMP6_SIZE	= ffi.sizeof("struct stats_net_icmp6");

	STATS_NET_EICMP6_SIZE	= ffi.sizeof("struct stats_net_eicmp6");
	STATS_NET_UDP6_SIZE	= ffi.sizeof("struct stats_net_udp6");
	STATS_NET_SOCK6_SIZE	= ffi.sizeof("struct stats_net_sock6");
	STATS_PWR_CPUFREQ_SIZE	= ffi.sizeof("struct stats_pwr_cpufreq");
	STATS_HUGE_SIZE	= ffi.sizeof("struct stats_memory");
	STATS_PWR_WGHFREQ_SIZE	= ffi.sizeof("struct stats_pwr_wghfreq");
	STATS_PWR_USB_SIZE	= ffi.sizeof("struct stats_pwr_usb");
	STATS_FILESYSTEM_SIZE	= ffi.sizeof("struct stats_filesystem");
	STATS_FCHOST_SIZE	= ffi.sizeof("struct stats_fchost");
}


local exports = {
	Constants = Constants;
}

return exports;
