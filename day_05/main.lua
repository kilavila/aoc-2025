local ingredient_id_ranges = {}
local ingredient_ids = {}

for line in io.lines("./input.txt", "*l") do
	local range = line:match("^%d+%-%d+$")
	if range then
		table.insert(ingredient_id_ranges, range)
	end

	local id = line:match("^%d+$")
	if id then
		table.insert(ingredient_ids, id)
	end
end

local p1_sum = 0
local p2_sum = 0

-- INFO: PART 1

local function check_id(id, range)
	local min, max = range:match("^(%d+)%-(%d+)$")

	if tonumber(id) >= tonumber(min) and tonumber(id) <= tonumber(max) then
		return true
	end

	return false
end

for _, id in ipairs(ingredient_ids) do
	for _, range in ipairs(ingredient_id_ranges) do
		local is_in_range = check_id(id, range)
		if is_in_range then
			p1_sum = p1_sum + 1
			break
		end
	end
end

-- INFO: PART 2

table.sort(ingredient_id_ranges, function(a, b)
	local aa, ab = a:match("^(%d+)%-(%d+)$")
	local ba, bb = b:match("^(%d+)%-(%d+)$")

	aa, ab = tonumber(aa), tonumber(ab)
	ba, bb = tonumber(ba), tonumber(bb)

	return aa < ba
end)

local parsed_ranges = {}

for _, range in ipairs(ingredient_id_ranges) do
	local min, max = range:match("^(%d+)%-(%d+)$")

	local duplicate = false

	for _, existing in ipairs(parsed_ranges) do
		if min == existing.min and max == existing.max then
			duplicate = true
		end
	end

	if not duplicate then
		local new = {
			min = min,
			max = max,
		}

		table.insert(parsed_ranges, new)
	end
end

-- all duplicates should be gone

for key, range in ipairs(parsed_ranges) do
	for i = key + 1, #parsed_ranges, 1 do
		if type(range) == "table" and type(parsed_ranges[i]) == "table" then
			if tonumber(range.max) >= tonumber(parsed_ranges[i].min) then
				parsed_ranges[key].max = parsed_ranges[i].max
				parsed_ranges[i] = "removed"
			end
		end
	end
end

-- wtf am I doing???

local test = {}

for _, r in ipairs(parsed_ranges) do
	if type(r) == "table" then
		print(r.min .. "-" .. r.max)
		table.insert(test, r)
	else
		print(r)
	end
end

for key, range in ipairs(test) do
	for i = key + 1, #test, 1 do
		if type(range) == "table" and type(test[i]) == "table" then
			if tonumber(range.max) >= tonumber(test[i].min) then
				test[key].max = test[i].max
				test[i] = "removed"
			end
		end
	end
end

-- any overlapping ranges should be gone

local test2 = {}

for _, r in ipairs(test) do
	if type(r) == "table" then
		print(r.min .. "-" .. r.max)
		table.insert(test2, r)
	else
		print(r)
	end
end

-- INFO: SUM
for _, range in ipairs(test2) do
	local sum = range.max - range.min + 1
	p2_sum = p2_sum + sum
end

print()
print(p1_sum)
print(string.format('%i', p2_sum))

-- Correct p1: 698
--         p2: 271456926034589 too low
--             274068083644613 wrong
--             319265493577458 wrong
--             328359266119885 wrong
--             337591730380065 wrong
--             353065269189388 wrong
--             447509460007256 wrong
--             447509460006892 too high
