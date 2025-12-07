local timer = {}
timer.start = os.clock()

local lines = {}
local beam_splits = {}

local p1_sum = 0
local p2_sum = 0

for line in io.lines("./input.txt", "*l") do
	table.insert(lines, line)
end

local function update_beam_splits(updated_splits)
	for _, bs in ipairs(beam_splits) do
		if bs == "removed" then
			goto skip_bs
		end

		local existing = false

		for _, us in ipairs(updated_splits) do
			if bs == us then
				existing = true
			end
		end

		if not existing then
			table.insert(updated_splits, bs)
		end

		::skip_bs::
	end

	beam_splits = updated_splits
end

local function find_start(line)
	local i = 1

	for char in line:gmatch(".") do
		if char == "S" then
			break
		end

		i = i + 1
	end

	return i
end

local start_col = find_start(lines[1])
table.insert(beam_splits, start_col)

-- INFO: PART 1

for row = 1, #lines, 1 do
	local line = lines[row]
	local updated_splits = {}

	for idx, col in ipairs(beam_splits) do
		if col == "removed" then
			goto skip_split
		end

		local char = line:sub(col, col)
		if char == "^" then
			local split_left = col - 1
			local split_right = col + 1

			beam_splits[idx] = "removed"

			if split_left >= 0 then
				table.insert(updated_splits, split_left)
			end

			if split_right <= #line then
				table.insert(updated_splits, split_right)
			end

			p1_sum = p1_sum + 1
		end

		::skip_split::
	end

	update_beam_splits(updated_splits)
end

-- INFO: PART 2

local lines_p2 = {}

for _, line in ipairs(lines) do
	local chars = {}

	for char in line:gmatch(".") do
		if char == "S" then
			table.insert(chars, tonumber(1))
		elseif char == "." then
			table.insert(chars, tonumber(0))
		elseif char == "^" then
			table.insert(chars, tonumber(-1))
		end
	end

	table.insert(lines_p2, chars)
end

for row = 2, #lines_p2, 1 do
	local line = lines_p2[row]
	local prev_line = lines_p2[row - 1]

	for col, num in ipairs(line) do
		local prev_num = prev_line[col]

		if num >= 0 then
			line[col] = line[col] + prev_num
		elseif num == -1 then
			line[col] = line[col] + 1
			line[col - 1] = line[col - 1] + prev_num
			line[col + 1] = line[col + 1] + prev_num
		end
	end

	lines_p2[row] = line
end

local last_line = lines_p2[#lines_p2 - 1]
local last_line_str = table.concat(last_line, " ")
last_line_str = last_line_str:gsub(" 0 ", " ")
last_line_str = last_line_str:gsub(" ", " + ")

local calc = load("return " .. last_line_str)
if calc then
	local sum = calc()
	p2_sum = sum
end

print(p1_sum)
print(p2_sum)

timer.stop = os.clock()
timer.diff = (timer.stop - timer.start) * 1000
print(timer.diff .. "ms")
