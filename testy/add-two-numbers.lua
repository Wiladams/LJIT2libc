--add-two-numbers.lua
--
-- http://www.programmingsimplified.com/c-program-add-two-numbers
--

local init = require("test_setup")()
local ffi = require("ffi")

local int = ffi.typeof("int")
local int_a = ffi.typeof("int[?]")
 

local a, b = int_a(1),int_a(1);
 
printf("Enter two numbers to add\n");
scanf("%d%d",a,b);
 
local c = a[0] + b[0];
 
printf("Sum of entered numbers = %d\n",int(c));
 
return true;