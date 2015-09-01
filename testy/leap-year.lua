-- leap-year.lua
-- http://www.programmingsimplified.com/c/source-code/c-program-check-leap-year
--

local init = require("test_setup")()
local ffi = require("ffi")

local int = ffi.typeof("int")
local year = ffi.new("int[1]");

printf("Enter a year to check if it is a leap year\n");
scanf("%d", year);
year = int(year[0]);

if ( year%400 == 0) then
  printf("%d is a leap year.\n", year);
elseif ( year%100 == 0) then
  printf("%d is not a leap year.\n", year);
elseif ( year%4 == 0 ) then
  printf("%d is a leap year.\n", year);
else
  printf("%d is not a leap year.\n", year);  
end