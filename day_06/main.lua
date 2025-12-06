local timer = {}
timer.start = os.clock()

local input = "./input.txt"

-- INFO: PART 1

local rotated = {}
local p1_sum = tonumber(0)

for line in io.lines(input, "*l") do
	for op in line:gmatch("[%*|%+]") do
		table.insert(rotated, op)
	end
end

local idx = 1
for line in io.lines(input, "*l") do
	for num in line:gmatch("%d+") do
		local str = rotated[idx]
		rotated[idx] = str .. " " .. num

		if idx >= #rotated then
			idx = 1
		else
			idx = idx + 1
		end
	end
end

for _, line in ipairs(rotated) do
	local op = line:match("[%*|%+]")
	local eq = ""

	for num in line:gmatch("%d+") do
		if eq == "" then
			eq = num
		else
			eq = eq .. " " .. op .. " " .. num
		end
	end

	local calc = load("return " .. eq)
	if calc then
		local sum = calc()
		p1_sum = p1_sum + sum
	end
end

-- INFO: PART 2

local rotated_all_chars = {}
local p2_sum = tonumber(0)

local i = 1
for line in io.lines(input, "*l") do
	for char in line:gmatch(".") do
		local str = rotated_all_chars[i]
		if not str then
			rotated_all_chars[i] = char
		else
			rotated_all_chars[i] = str .. " " .. char
		end

		if i >= #line then
			i = 1
		else
			i = i + 1
		end
	end
end

for key, line in ipairs(rotated_all_chars) do
	local op = line:match("[%*|%+]")
	if op then
		line = line:gsub(op, "")
		line = line:gsub(" ", "")

		local eq = line

		for i = key + 1, #rotated_all_chars, 1 do
			local next_line = rotated_all_chars[i]
			next_line = next_line:gsub(" ", "")

			if next_line == "" then break end

			eq = eq .. " " .. op .. " " .. next_line
		end

		local calc = load("return " .. eq)
		if calc then
			local sum = calc()
			p2_sum = p2_sum + sum
		end
	end
end


print(p1_sum)
print(p2_sum)

timer.stop = os.clock()
timer.diff = (timer.stop - timer.start) * 1000
print(timer.diff .. "ms")
