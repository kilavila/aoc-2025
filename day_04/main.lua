local timer = {}
timer.start = os.clock()

local p1_diagram = {}
local p2_diagram = {}

local function searchAdjacentPositions(row, col)
	local prev_row = row - 1
	local next_row = row + 1
	local prev_col = col - 1
	local next_col = col + 1

	local adjacent_positions = {
		p2_diagram[tostring(prev_row .. ":" .. prev_col)],
		p2_diagram[tostring(prev_row .. ":" .. col)],
		p2_diagram[tostring(prev_row .. ":" .. next_col)],
		p2_diagram[tostring(row .. ":" .. prev_col)],
		p2_diagram[tostring(row .. ":" .. next_col)],
		p2_diagram[tostring(next_row .. ":" .. prev_col)],
		p2_diagram[tostring(next_row .. ":" .. col)],
		p2_diagram[tostring(next_row .. ":" .. next_col)],
	}

	local length = 0

	for _, v in pairs(adjacent_positions) do
		if v.row and v.col then
			length = length + 1
		end
	end

	if length < 4 then
		return true
	end

	return false
end

local row = 1
for line in io.lines("./input.txt", "*l") do
	for col = 1, #line, 1 do
		local char = line:sub(col, col)

		if char == "@" then
			local id = tostring(row .. ":" .. col)
			p1_diagram[id] = { row = row, col = col }
			p2_diagram[id] = { row = row, col = col }
		end
	end

	row = row + 1
end

local p1 = 0
local p2 = 0

for _, v in pairs(p1_diagram) do
	local isAccessible = searchAdjacentPositions(v.row, v.col)
	if isAccessible then
		p1 = p1 + 1
	end
end

while true do
	local accessed = 0

	for _, v in pairs(p2_diagram) do
		local isAccessible = searchAdjacentPositions(v.row, v.col)
		if isAccessible then
			local id = tostring(v.row .. ":" .. v.col)
			p2_diagram[id] = nil

			p2 = p2 + 1
			accessed = accessed + 1
		end
	end

	if accessed == 0 then
		break
	end
end

print(p1)
print(p2)

timer.stop = os.clock()
timer.diff = (timer.stop - timer.start) * 1000
print(timer.diff .. "ms")
