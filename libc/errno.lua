local errnos = require ("bits/errno")

local exports = {
	errnos = errnos;	
}

setmetatable(exports, {
	__call = function(self, tbl)
		tbl = tbl or _G;
		for k,v in pairs(self.errnos) do
			tbl[k] = v;
		end

		return self;
	end,
})

return exports