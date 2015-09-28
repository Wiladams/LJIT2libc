local ffi = require("ffi")
local utils = require("libc_utils")
require("sys/types")


local octal = utils.octal


require("bits/socket")

ffi.cdef[[
struct linger
{
	int l_onoff;
	int l_linger;
};

struct sockaddr
{
	sa_family_t sa_family;
	char sa_data[14];
};

struct sockaddr_storage
{
	sa_family_t ss_family;
	unsigned long __ss_align;
	char __ss_padding[128-2*sizeof(unsigned long)];
};
]]

--[=[
ffi.cdef[[
struct ucred
{
	pid_t pid;
	uid_t uid;
	gid_t gid;
};
--]=]

ffi.cdef[[
struct mmsghdr
{
	struct msghdr msg_hdr;
	unsigned int  msg_len;
};
]]

ffi.cdef[[
int socket (int, int, int);
int socketpair (int, int, int, int [2]);

int shutdown (int, int);

int bind (int, const struct sockaddr *, socklen_t);
int connect (int, const struct sockaddr *, socklen_t);
int listen (int, int);
int accept (int, struct sockaddr *__restrict, socklen_t *__restrict);
int accept4(int, struct sockaddr *__restrict, socklen_t *__restrict, int);

int getsockname (int, struct sockaddr *__restrict, socklen_t *__restrict);
int getpeername (int, struct sockaddr *__restrict, socklen_t *__restrict);

ssize_t send (int, const void *, size_t, int);
ssize_t recv (int, void *, size_t, int);
ssize_t sendto (int, const void *, size_t, int, const struct sockaddr *, socklen_t);
ssize_t recvfrom (int, void *__restrict, size_t, int, struct sockaddr *__restrict, socklen_t *__restrict);
//ssize_t sendmsg (int, const struct msghdr *, int);
//ssize_t recvmsg (int, struct msghdr *, int);

int getsockopt (int, int, int, void *__restrict, socklen_t *__restrict);
int setsockopt (int, int, int, const void *, socklen_t);

int sockatmark (int);
]]

local Functions = {
	socket = ffi.C.socket;
	socketpair = ffi.C.socketpair;
	shutdown = ffi.C.shutdown;
	bind = ffi.C.bind;
	connect = ffi.C.connect;
	listen = ffi.C.listen;
	accept = ffi.C.accept;
	accept4 = ffi.C.accept4;
	getsockname = ffi.C.getsockname;
	getpeername = ffi.C.getpeername;
	send = ffi.C.send;
	recv = ffi.C.recv;
	sendto = ffi.C.sendto;
	recvfrom = ffi.C.recvfrom;
	getsockopt = ffi.C.getsockopt;
	setsockopt = ffi.C.setsockopt;
	sockatmark = ffi.C.sockatmark;
}

local Constants = {
	SHUT_RD =0;
	SHUT_WR =1;
	SHUT_RDWR =2;

	-- Type of sockets
	SOCK_STREAM    =1;
	SOCK_DGRAM     =2;
	SOCK_RAW       =3;
	SOCK_RDM       =4;
	SOCK_SEQPACKET =5;
	SOCK_DCCP      =6;
	SOCK_PACKET    =10;

	SOCK_CLOEXEC   = octal('02000000');
	SOCK_NONBLOCK  = octal('04000');

	-- protocol family
	PF_UNSPEC       =0;
	PF_LOCAL        =1;
	PF_UNIX         =1;		-- PF_LOCAL
	PF_FILE         =1;		-- PF_LOCAL
	PF_INET         =2;
	PF_AX25         =3;
	PF_IPX          =4;
	PF_APPLETALK    =5;
	PF_NETROM       =6;
	PF_BRIDGE       =7;
	PF_ATMPVC       =8;
	PF_X25          =9;
	PF_INET6        =10;
	PF_ROSE         =11;
	PF_DECnet       =12;
	PF_NETBEUI      =13;
	PF_SECURITY     =14;
	PF_KEY          =15;
	PF_NETLINK      =16;
	PF_ROUTE        =16;	-- PF_NETLINK
	PF_PACKET       =17;
	PF_ASH          =18;
	PF_ECONET       =19;
	PF_ATMSVC       =20;
	PF_RDS          =21;
	PF_SNA          =22;
	PF_IRDA         =23;
	PF_PPPOX        =24;
	PF_WANPIPE      =25;
	PF_LLC          =26;
	PF_IB           =27;
	PF_CAN          =29;
	PF_TIPC         =30;
	PF_BLUETOOTH    =31;
	PF_IUCV         =32;
	PF_RXRPC        =33;
	PF_ISDN         =34;
	PF_PHONET       =35;
	PF_IEEE802154   =36;
	PF_CAIF         =37;
	PF_ALG          =38;
	PF_NFC          =39;
	PF_VSOCK        =40;
	PF_MAX          =41;


	AF_UNSPEC       =0;
	AF_LOCAL        =1;
	AF_UNIX         =1;		-- AF_LOCAL
	AF_FILE         =1;		-- AF_LOCAL
	AF_INET         =2;
	AF_AX25         =3;
	AF_IPX          =4;
	AF_APPLETALK    =5;
	AF_NETROM       =6;
	AF_BRIDGE       =7;
	AF_ATMPVC       =8;
	AF_X25          =9;
	AF_INET6        =10;
	AF_ROSE         =11;
	AF_DECnet       =12;
	AF_NETBEUI      =13;
	AF_SECURITY     =14;
	AF_KEY          =15;
	AF_NETLINK      =16;
	AF_ROUTE        =16;	-- AF_NETLINK
	AF_PACKET       =17;
	AF_ASH          =18;
	AF_ECONET       =19;
	AF_ATMSVC       =20;
	AF_RDS          =21;
	AF_SNA          =22;
	AF_IRDA         =23;
	AF_PPPOX        =24;
	AF_WANPIPE      =25;
	AF_LLC          =26;
	AF_IB           =27;
	AF_CAN          =29;
	AF_TIPC         =30;
	AF_BLUETOOTH    =31;
	AF_IUCV         =32;
	AF_RXRPC        =33;
	AF_ISDN         =34;
	AF_PHONET       =35;
	AF_IEEE802154   =36;
	AF_CAIF         =37;
	AF_ALG          =38;
	AF_NFC          =39;
	AF_VSOCK        =40;
	AF_MAX          =41;


	-- Socket options
	SO_DEBUG        = 1;
	SO_REUSEADDR    = 2;
	SO_TYPE         = 3;
	SO_ERROR        = 4;
	SO_DONTROUTE    = 5;
	SO_BROADCAST    = 6;
	SO_SNDBUF       = 7;
	SO_RCVBUF       = 8;
	SO_KEEPALIVE    = 9;
	SO_OOBINLINE    = 10;
	SO_NO_CHECK     = 11;
	SO_PRIORITY     = 12;
	SO_LINGER       = 13;
	SO_BSDCOMPAT    = 14;
	SO_REUSEPORT    = 15;
	SO_PASSCRED     = 16;
	SO_PEERCRED     = 17;
	SO_RCVLOWAT     = 18;
	SO_SNDLOWAT     = 19;
	SO_RCVTIMEO     = 20;
	SO_SNDTIMEO     = 21;
	SO_ACCEPTCONN   = 30;
	SO_SNDBUFFORCE  = 32;
	SO_RCVBUFFORCE  = 33;
	SO_PROTOCOL     = 38;
	SO_DOMAIN       = 39;


	SO_SECURITY_AUTHENTICATION            =  22;
	SO_SECURITY_ENCRYPTION_TRANSPORT      =  23;
	SO_SECURITY_ENCRYPTION_NETWORK        =  24;

	SO_BINDTODEVICE =25;

	SO_ATTACH_FILTER        =26;
	SO_DETACH_FILTER        =27;
	SO_GET_FILTER           =26;	-- SO_ATTACH_FILTER

	SO_PEERNAME             =28;
	SO_TIMESTAMP            =29;
	SCM_TIMESTAMP           =29;	-- SO_TIMESTAMP

	SO_PEERSEC              =31;
	SO_PASSSEC              =34;
	SO_TIMESTAMPNS          =35;
	SCM_TIMESTAMPNS         =35;	-- SO_TIMESTAMPNS
	SO_MARK                 =36;
	SO_TIMESTAMPING         =37;
	SCM_TIMESTAMPING        =37;	-- SO_TIMESTAMPING
	SO_RXQ_OVFL             =40;
	SO_WIFI_STATUS          =41;
	SCM_WIFI_STATUS         =41;	-- SO_WIFI_STATUS
	SO_PEEK_OFF             =42;
	SO_NOFCS                =43;
	SO_LOCK_FILTER          =44;
	SO_SELECT_ERR_QUEUE     =45;
	SO_BUSY_POLL            =46;
	SO_MAX_PACING_RATE      =47;
	SO_BPF_EXTENSIONS       =48;
	SO_INCOMING_CPU         =49;
	SO_ATTACH_BPF           =50;
	SO_DETACH_BPF           =50;	-- SO_DETACH_FILTER

	SOL_SOCKET      =1;


	SOL_IP          =0;
	SOL_IPV6        =41;
	SOL_ICMPV6      =58;

	SOL_RAW         =255;
	SOL_DECNET      =261;
	SOL_X25         =262;
	SOL_PACKET      =263;
	SOL_ATM         =264;
	SOL_AAL         =265;
	SOL_IRDA        =266;

	SOMAXCONN       =128;

	MSG_OOB       =0x0001;
	MSG_PEEK      =0x0002;
	MSG_DONTROUTE =0x0004;
	MSG_CTRUNC    =0x0008;
	MSG_PROXY     =0x0010;
	MSG_TRUNC     =0x0020;
	MSG_DONTWAIT  =0x0040;
	MSG_EOR       =0x0080;
	MSG_WAITALL   =0x0100;
	MSG_FIN       =0x0200;
	MSG_SYN       =0x0400;
	MSG_CONFIRM   =0x0800;
	MSG_RST       =0x1000;
	MSG_ERRQUEUE  =0x2000;
	MSG_NOSIGNAL  =0x4000;
	MSG_MORE      =0x8000;
	MSG_WAITFORONE =0x10000;
	MSG_CMSG_CLOEXEC =0x40000000;

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