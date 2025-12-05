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
local p2_sum = tonumber(0)

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

while true do
	local updated_ranges = {}
	local found_overlap = false

	for key, range in ipairs(ingredient_id_ranges) do
		if range == "removed" then
			goto skip
		end

		local min, max = range:match("^(%d+)%-(%d+)")

		for i = key + 1, #ingredient_id_ranges, 1 do
			local r = ingredient_id_ranges[i]
			if r == "removed" then
				goto next
			end

			local r_min, r_max = r:match("^(%d+)%-(%d+)")

			if tonumber(max) >= tonumber(r_max) then
				ingredient_id_ranges[i] = "removed"
				found_overlap = true
			elseif tonumber(max) >= tonumber(r_min) then
				max = r_max
				ingredient_id_ranges[i] = "removed"
				found_overlap = true
			else
				break
			end

			::next::
		end

		table.insert(updated_ranges, min .. "-" .. max)

		::skip::
	end

	if not found_overlap then break end
	ingredient_id_ranges = updated_ranges
end

for _, range in ipairs(ingredient_id_ranges) do
	local min, max = range:match("^(%d+)%-(%d+)")
	min, max = tonumber(min), tonumber(max)

	local sum = (max - min) + 1
	p2_sum = p2_sum + sum
end

print()
print(p1_sum)
print(string.format('%i', p2_sum))
