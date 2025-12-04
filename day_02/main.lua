local timer = {}
timer.start = os.clock()

local function check_number(str, mod)
	local prev = nil

	for m in str:gmatch(string.rep("%d", #str / mod, "")) do
		if prev ~= nil and prev ~= m then
			return true
		end

		prev = m
	end

	return false
end

local p1 = 0
local p2 = 0

for line in io.lines("./input.txt", "*l") do
	for m in line:gmatch("%d+%-%d+") do
		local start, stop = m:match("^(%d+)%-(%d+)")

		for i = start, stop, 1 do
			local id = tostring(i)

			for mod = 2, #id, 1 do
				if #id % mod == 0 and not check_number(id, mod) then
					p2 = p2 + id

					if mod == 2 then
						p1 = p1 + id
					end

					break
				end
			end
		end
	end
end

print(p1)
print(p2)

timer.stop = os.clock()
timer.diff = (timer.stop - timer.start) * 1000
print(timer.diff .. "ms")
