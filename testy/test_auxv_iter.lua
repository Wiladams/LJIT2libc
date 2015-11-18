-- test_syscall.lua
-- References
--	ld-linux.so
--  getauxval
local init = require("test_setup")()
local auxv_util = require("auxv_iter")
local apairs = auxv_util.keyvaluepairs;
local keynames = auxv_util.keynames;
local auxvGetOne = auxv_util.getOne;


--auxv_util.gencdefs();
print("==== Iterate All ====")
local function printAll()
	for _, key, value in apairs(path) do
		io.write(string.format("%20s[%2d] : ", keynames[key], key))
		print(value);
	end
end

-- print all the entries
printAll();

-- try to get a specific one
print("==== Get Singles ====")
print(" Platform: ", auxvGetOne(auxv_util.AT_PLATFORM))
print("Page Size: ", auxvGetOne(auxv_util.AT_PAGESZ))


