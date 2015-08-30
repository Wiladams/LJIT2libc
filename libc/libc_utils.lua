--libc_utils.lua

local function copyPairs(srcTbl, dstTbl)
	dstTbl = dstTbl or _G
	
	for k,v in pairs(srcTbl) do
		dstTbl[k] = v;
	end
end

local function octal(val)
	return tonumber(val,8);
end

local exports = {
	copyPairs = copyPairs;
	octal = octal;
}

return exports
