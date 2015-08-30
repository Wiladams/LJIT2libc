local ffi = require("ffi")
local utils = require("libc_utils")


require ("sys/types")
require ("sys/socket")


ffi.cdef[[
typedef uint32_t tcp_seq;
]]

-- This structure can be used if you're going to access
-- the tcp header right on the wire.

if ffi.abi("le") then
ffi.cdef[[
struct tcphdr {
	union { 
		struct {
			uint16_t source;
			uint16_t dest;
			uint32_t seq;
			uint32_t ack_seq;
			uint16_t res1:4;
			uint16_t doff:4;
			uint16_t fin:1;
			uint16_t syn:1;
			uint16_t rst:1;
			uint16_t psh:1;
			uint16_t ack:1;
			uint16_t urg:1;
			uint16_t res2:2;

			uint16_t window;
			uint16_t check;
			uint16_t urg_ptr;
		}; 

		struct {

	uint16_t th_sport;
	uint16_t th_dport;
	uint32_t th_seq;
	uint32_t th_ack;
	uint8_t th_x2:4;
	uint8_t th_off:4;
	uint8_t th_flags;
	uint16_t th_win;
	uint16_t th_sum;
	uint16_t th_urp;

	}; };

};
]]
else
ffi.cdef[[
struct tcphdr {
	union { struct {

	uint16_t source;
	uint16_t dest;
	uint32_t seq;
	uint32_t ack_seq;

	uint16_t doff:4;
	uint16_t res1:4;
	uint16_t res2:2;
	uint16_t urg:1;
	uint16_t ack:1;
	uint16_t psh:1;
	uint16_t rst:1;
	uint16_t syn:1;
	uint16_t fin:1;

	uint16_t window;
	uint16_t check;
	uint16_t urg_ptr;

	}; 

	struct {

	uint16_t th_sport;
	uint16_t th_dport;
	uint32_t th_seq;
	uint32_t th_ack;
	uint8_t th_off:4;
	uint8_t th_x2:4;
	uint8_t th_flags;
	uint16_t th_win;
	uint16_t th_sum;
	uint16_t th_urp;

	}; 
	};
};
]]
end 

ffi.cdef[[
struct tcp_info
{
	uint8_t tcpi_state;
	uint8_t tcpi_ca_state;
	uint8_t tcpi_retransmits;
	uint8_t tcpi_probes;
	uint8_t tcpi_backoff;
	uint8_t tcpi_options;
	uint8_t tcpi_snd_wscale : 4, tcpi_rcv_wscale : 4;
	uint32_t tcpi_rto;
	uint32_t tcpi_ato;
	uint32_t tcpi_snd_mss;
	uint32_t tcpi_rcv_mss;
	uint32_t tcpi_unacked;
	uint32_t tcpi_sacked;
	uint32_t tcpi_lost;
	uint32_t tcpi_retrans;
	uint32_t tcpi_fackets;
	uint32_t tcpi_last_data_sent;
	uint32_t tcpi_last_ack_sent;
	uint32_t tcpi_last_data_recv;
	uint32_t tcpi_last_ack_recv;
	uint32_t tcpi_pmtu;
	uint32_t tcpi_rcv_ssthresh;
	uint32_t tcpi_rtt;
	uint32_t tcpi_rttvar;
	uint32_t tcpi_snd_ssthresh;
	uint32_t tcpi_snd_cwnd;
	uint32_t tcpi_advmss;
	uint32_t tcpi_reordering;
	uint32_t tcpi_rcv_rtt;
	uint32_t tcpi_rcv_space;
	uint32_t tcpi_total_retrans;
	uint64_t tcpi_pacing_rate;
	uint64_t tcpi_max_pacing_rate;
};
]]

ffi.cdef[[
static const int TCP_MD5SIG_MAXKEYLEN   = 80;

struct tcp_md5sig
{
	struct sockaddr_storage tcpm_addr;
	uint16_t __tcpm_pad1;
	uint16_t tcpm_keylen;
	uint32_t __tcpm_pad2;
	uint8_t tcpm_key[TCP_MD5SIG_MAXKEYLEN];
};
]]



local Constants = {
	SOL_TCP = 6;
	
	TH_FIN = 0x01;
	TH_SYN = 0x02;
	TH_RST = 0x04;
	TH_PUSH = 0x08;
	TH_ACK = 0x10;
	TH_URG = 0x20;

	TCP_NODELAY = 1;
	TCP_MAXSEG	= 2;
	TCP_CORK	= 3;
	TCP_KEEPIDLE	= 4;
	TCP_KEEPINTVL	= 5;
	TCP_KEEPCNT	 = 6;
	TCP_SYNCNT	 = 7;
	TCP_LINGER2	 = 8;
	TCP_DEFER_ACCEPT = 9;
	TCP_WINDOW_CLAMP = 10;
	TCP_INFO	 = 11;
	TCP_QUICKACK	 = 12;
	TCP_CONGESTION	 = 13;
	TCP_MD5SIG	 = 14;
	TCP_THIN_LINEAR_TIMEOUTS = 16;
	TCP_THIN_DUPACK  = 17;
	TCP_USER_TIMEOUT = 18;
	TCP_REPAIR       = 19;
	TCP_REPAIR_QUEUE = 20;
	TCP_QUEUE_SEQ    = 21;
	TCP_REPAIR_OPTIONS = 22;
	TCP_FASTOPEN     = 23;
	TCP_TIMESTAMP    = 24;
	TCP_NOTSENT_LOWAT = 25;

	TCP_ESTABLISHED  = 1;
	TCP_SYN_SENT     = 2;
	TCP_SYN_RECV     = 3;
	TCP_FIN_WAIT1    = 4;
	TCP_FIN_WAIT2    = 5;
	TCP_TIME_WAIT    = 6;
	TCP_CLOSE        = 7;
	TCP_CLOSE_WAIT   = 8;
	TCP_LAST_ACK     = 9;
	TCP_LISTEN       = 10;
	TCP_CLOSING      = 11;

	TCPI_OPT_TIMESTAMPS	= 1;
	TCPI_OPT_SACK		= 2;
	TCPI_OPT_WSCALE		= 4;
	TCPI_OPT_ECN		= 8;

	TCP_CA_Open		= 0;
	TCP_CA_Disorder	= 1;
	TCP_CA_CWR		= 2;
	TCP_CA_Recovery	= 3;
	TCP_CA_Loss		= 4;
}



local exports = {
	Constants = Constants;
	Functions = Functions;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Constants, tbl);
		utils.copyPairs(self.Functions, tbl);

		return self
	end,
})

return exports
