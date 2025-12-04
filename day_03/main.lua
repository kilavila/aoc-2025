local timer = {}
timer.start = os.clock()

local function sliceLine(line, length)
	local tbl = {}
	local slice = line:sub(1, length)

	for i = 1, #slice, 1 do
		local num = slice:sub(i, i)
		table.insert(tbl, { val = num, idx = i })
	end

	return tbl
end

local function findLargerNumber(line, num, stop_idx)
	local isUpdated = false

	for i = num.idx + 1, stop_idx, 1 do
		local curr = line:sub(i, i)

		if tonumber(curr) >= tonumber(num.val) then
			num.val = curr
			num.idx = i
			isUpdated = true
		end
	end

	return isUpdated, num
end

local function findJoltage(line, batt_num)
	local reverse_line = string.reverse(line)
	local slice_tbl = sliceLine(reverse_line, batt_num)

	for i = #slice_tbl, 1, -1 do
		local curr_num = slice_tbl[i]
		local prev_num_idx = i + 1
		local prev_num = slice_tbl[prev_num_idx]
		local stop_idx = #line

		if i ~= #slice_tbl then
			stop_idx = prev_num.idx - 1
		end

		local isUpdated, new = findLargerNumber(reverse_line, curr_num, stop_idx)
		if not isUpdated then break end

		curr_num.val = new.val
		curr_num.idx = new.idx
	end

	local reverse_slice = ""

	for _, num in ipairs(slice_tbl) do
		reverse_slice = reverse_slice .. num.val
	end

	local slice = string.reverse(reverse_slice)

	return tonumber(slice)
end

local p1_sum = 0
local p2_sum = 0

for line in io.lines("./input.txt", "*l") do
	local p1 = findJoltage(line, 2)
	local p2 = findJoltage(line, 12)

	p1_sum = p1_sum + p1
	p2_sum = p2_sum + p2
end

print(p1_sum)
print(string.format('%i', p2_sum))

timer.stop = os.clock()
timer.diff = (timer.stop - timer.start) * 1000
print(timer.diff .. "ms")
