local utils = require("libc_utils")
local octal = utils.octal

local Constants = {}
Constants.O_CREAT        =octal('0100');
Constants.O_EXCL         =octal('0200');
Constants.O_NOCTTY       =octal('0400');
Constants.O_TRUNC       =octal('01000');
Constants.O_APPEND      =octal('02000');
Constants.O_NONBLOCK    =octal('04000');
Constants.O_DSYNC      =octal('010000');
Constants.O_SYNC     =octal('04010000');
Constants.O_RSYNC    =octal('04010000');
Constants.O_DIRECTORY =octal('0200000');
Constants.O_NOFOLLOW  =octal('0400000');
Constants.O_CLOEXEC  =octal('02000000');

Constants.O_ASYNC      =octal('020000');
Constants.O_DIRECT     =octal('040000');
Constants.O_LARGEFILE =octal('0100000');
Constants.O_NOATIME  =octal('01000000');
Constants.O_PATH    =octal('010000000');
Constants.O_TMPFILE =octal('020200000');
Constants.O_NDELAY = Constants.O_NONBLOCK;

Constants.F_DUPFD  =0;
Constants.F_GETFD  =1;
Constants.F_SETFD  =2;
Constants.F_GETFL  =3;
Constants.F_SETFL  =4;

Constants.F_SETOWN =8;
Constants.F_GETOWN =9;
Constants.F_SETSIG =10;
Constants.F_GETSIG =11;

Constants.F_GETLK =12;
Constants.F_SETLK =13;
Constants.F_SETLKW =14;

Constants.F_SETOWN_EX =15;
Constants.F_GETOWN_EX =16;

Constants.F_GETOWNER_UIDS =17;


return Constants
