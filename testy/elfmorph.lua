--elfmorph.lua
-- This little utility turns #define constants
-- into static const int

function startswith(s, prefix)
	return string.find(s, prefix, 1, true) == 1
end

local pattern = "^static const int%s*(%g+)%s*(%g+);"
for line in io.lines("elf.lua") do
	if startswith(line, "static const int") then
		local name, value = line:match(pattern)
		if name ~= nil and value ~= nil then
			print(string.format("static const int %s = %s;", name, value))
		end
	else
		print(line)
	end
end
