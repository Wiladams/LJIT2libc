--[[
	Ideally most of this should be in sys/ioctl, and only the very 
	arch specific stuff should be dealt with here.
--]]

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift
local utils = require("libc_utils")

-- very x86_64 specific
local IOC = {
  DIRSHIFT = 30;
  TYPESHIFT = 8;
  NRSHIFT = 0;
  SIZESHIFT = 16;
}

local function ioc(dir, ch, nr, size)
  if type(ch) == "string" then ch = ch:byte() end

  return bor(lshift(dir, IOC.DIRSHIFT), 
       lshift(ch, IOC.TYPESHIFT), 
       lshift(nr, IOC.NRSHIFT), 
       lshift(size, IOC.SIZESHIFT))
end

local function _IOC(a,b,c,d) 
  return ioc(a,b,c,d);
end


local _IOC_NONE  = 0;
local _IOC_WRITE = 1;
local _IOC_READ  = 2;

local function _IO(a,b) return _IOC(_IOC_NONE,a,b,0) end
local function _IOW(a,b,c) return _IOC(_IOC_WRITE,a,b,ffi.sizeof(c)) end
local function _IOR(a,b,c) return _IOC(_IOC_READ,a,b,ffi.sizeof(c)) end
local function _IOWR(a,b,c) return _IOC(bor(_IOC_READ,_IOC_WRITE),a,b,ffi.sizeof(c)) end

ffi.cdef[[
struct winsize {
	unsigned short ws_row;
	unsigned short ws_col;
	unsigned short ws_xpixel;
	unsigned short ws_ypixel;
};
]]

local Constants = {
	TCGETS		= 0x5401;
	TCSETS		= 0x5402;
	TCSETSW		= 0x5403;
	TCSETSF		= 0x5404;
	TCGETA		= 0x5405;
	TCSETA		= 0x5406;
	TCSETAW		= 0x5407;
	TCSETAF		= 0x5408;
	TCSBRK		= 0x5409;
	TCXONC		= 0x540A;
	TCFLSH		= 0x540B;
	TIOCEXCL	= 0x540C;
	TIOCNXCL	= 0x540D;
	TIOCSCTTY	= 0x540E;
	TIOCGPGRP	= 0x540F;
	TIOCSPGRP	= 0x5410;
	TIOCOUTQ	= 0x5411;
	TIOCSTI		= 0x5412;
	TIOCGWINSZ	= 0x5413;
	TIOCSWINSZ	= 0x5414;
	TIOCMGET	= 0x5415;
	TIOCMBIS	= 0x5416;
	TIOCMBIC	= 0x5417;
	TIOCMSET	= 0x5418;
	TIOCGSOFTCAR	= 0x5419;
	TIOCSSOFTCAR	= 0x541A;
	FIONREAD	= 0x541B;
	TIOCINQ		= 0x541B;	-- FIONREAD;
	TIOCLINUX	= 0x541C;
	TIOCCONS	= 0x541D;
	TIOCGSERIAL	= 0x541E;
	TIOCSSERIAL	= 0x541F;
	TIOCPKT		= 0x5420;
	FIONBIO		= 0x5421;
	TIOCNOTTY	= 0x5422;
	TIOCSETD	= 0x5423;
	TIOCGETD	= 0x5424;
	TCSBRKP		= 0x5425;
	TIOCTTYGSTRUCT	= 0x5426;
	TIOCSBRK	= 0x5427;
	TIOCCBRK	= 0x5428;
	TIOCGSID	= 0x5429;
	TIOCGPTN	= 0x80045430;
	TIOCSPTLCK	= 0x40045431;
	TCGETX          = 0x5432;
	TCSETX          = 0x5433;
	TCSETXF         = 0x5434;
	TCSETXW         = 0x5435;

	FIONCLEX	= 0x5450;
	FIOCLEX		= 0x5451;
	FIOASYNC	= 0x5452;
	TIOCSERCONFIG	= 0x5453;
	TIOCSERGWILD	= 0x5454;
	TIOCSERSWILD	= 0x5455;
	TIOCGLCKTRMIOS	= 0x5456;
	TIOCSLCKTRMIOS	= 0x5457;
	TIOCSERGSTRUCT	= 0x5458;
	TIOCSERGETLSR   = 0x5459;
	TIOCSERGETMULTI = 0x545A;
	TIOCSERSETMULTI = 0x545B;

	TIOCMIWAIT	= 0x545C;
	TIOCGICOUNT	= 0x545D;
	TIOCGHAYESESP   = 0x545E;
	TIOCSHAYESESP   = 0x545F;
	FIOQSIZE	= 0x5460;

	TIOCPKT_DATA		= 0;
	TIOCPKT_FLUSHREAD	= 1;
	TIOCPKT_FLUSHWRITE	= 2;
	TIOCPKT_STOP		= 4;
	TIOCPKT_START		= 8;
	TIOCPKT_NOSTOP		=16;
	TIOCPKT_DOSTOP		=32;
	TIOCPKT_IOCTL       =    64;

	TIOCSER_TEMT    = 0x01;



	TIOCM_LE        = 0x001;
	TIOCM_DTR       = 0x002;
	TIOCM_RTS       = 0x004;
	TIOCM_ST        = 0x008;
	TIOCM_SR        = 0x010;
	TIOCM_CTS       = 0x020;
	TIOCM_CAR       = 0x040;
	TIOCM_RNG       = 0x080;
	TIOCM_DSR       = 0x100;
	TIOCM_CD        = 0x040;	-- TIOCM_CAR;
	TIOCM_RI        = 0x080;	-- TIOCM_RNG;
	TIOCM_OUT1      = 0x2000;
	TIOCM_OUT2      = 0x4000;
	TIOCM_LOOP      = 0x8000;
	TIOCM_MODEM_BITS = 0x4000;	-- TIOCM_OUT2;

	N_TTY          = 0;
	N_SLIP         = 1;
	N_MOUSE        = 2;
	N_PPP          = 3;
	N_STRIP        = 4;
	N_AX25         = 5;
	N_X25          = 6;
	N_6PACK        = 7;
	N_MASC         = 8;
	N_R3964        = 9;
	N_PROFIBUS_FDL = 10;
	N_IRDA         = 11;
	N_SMSBLOCK     = 12;
	N_HDLC         = 13;
	N_SYNC_PPP     = 14;
	N_HCI          = 15;

	FIOSETOWN       = 0x8901;
	SIOCSPGRP       = 0x8902;
	FIOGETOWN       = 0x8903;
	SIOCGPGRP       = 0x8904;
	SIOCATMARK      = 0x8905;
	SIOCGSTAMP      = 0x8906;

	SIOCADDRT       = 0x890B;
	SIOCDELRT       = 0x890C;
	SIOCRTMSG       = 0x890D;

	SIOCGIFNAME     = 0x8910;
	SIOCSIFLINK     = 0x8911;
	SIOCGIFCONF     = 0x8912;
	SIOCGIFFLAGS    = 0x8913;
	SIOCSIFFLAGS    = 0x8914;
	SIOCGIFADDR     = 0x8915;
	SIOCSIFADDR     = 0x8916;
	SIOCGIFDSTADDR  = 0x8917;
	SIOCSIFDSTADDR  = 0x8918;
	SIOCGIFBRDADDR  = 0x8919;
	SIOCSIFBRDADDR  = 0x891a;
	SIOCGIFNETMASK  = 0x891b;
	SIOCSIFNETMASK  = 0x891c;
	SIOCGIFMETRIC   = 0x891d;
	SIOCSIFMETRIC   = 0x891e;
	SIOCGIFMEM      = 0x891f;
	SIOCSIFMEM      = 0x8920;
	SIOCGIFMTU      = 0x8921;
	SIOCSIFMTU      = 0x8922;
	SIOCSIFHWADDR   = 0x8924;
	SIOCGIFENCAP    = 0x8925;
	SIOCSIFENCAP    = 0x8926;
	SIOCGIFHWADDR   = 0x8927;
	SIOCGIFSLAVE    = 0x8929;
	SIOCSIFSLAVE    = 0x8930;
	SIOCADDMULTI    = 0x8931;
	SIOCDELMULTI    = 0x8932;
	SIOCGIFINDEX    = 0x8933;
	SIOGIFINDEX     = 0x8933;	-- SIOCGIFINDEX;
	SIOCSIFPFLAGS   = 0x8934;
	SIOCGIFPFLAGS   = 0x8935;
	SIOCDIFADDR     = 0x8936;
	SIOCSIFHWBROADCAST = 0x8937;
	SIOCGIFCOUNT    = 0x8938;

	SIOCGIFBR       = 0x8940;
	SIOCSIFBR       = 0x8941;

	SIOCGIFTXQLEN   = 0x8942;
	SIOCSIFTXQLEN   = 0x8943;

	SIOCDARP        = 0x8953;
	SIOCGARP        = 0x8954;
	SIOCSARP        = 0x8955;

	SIOCDRARP       = 0x8960;
	SIOCGRARP       = 0x8961;
	SIOCSRARP       = 0x8962;

	SIOCGIFMAP      = 0x8970;
	SIOCSIFMAP      = 0x8971;

	SIOCADDDLCI     = 0x8980;
	SIOCDELDLCI     = 0x8981;

	SIOCDEVPRIVATE  = 0x89F0;
	SIOCPROTOPRIVATE = 0x89E0;

	_IOC_NONE = _IOC_NONE;
	_IOC_WRITE = _IOC_WRITE;
	_IOC_READ = _IOC_READ;

}


local exports = {
	Constants = Constants;

	-- Functions
	_IOC = _IOC;
	_IO = _IO;
	_IOW = _IOW;
	_IOR = _IOR;
	_IOWR = _IOWR;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Constants, tbl);

		return self;
	end,
})

return exports
