local timer = {}
timer.start = os.clock()

local pos, lands_on, clicks_past = 50, 0, 0

for line in io.lines("./input.txt", "*l") do
	local dir, clicks = line:match("^(%w)(%d+)$")

	for i = 1, tonumber(clicks), 1 do
		if dir == "L" then
			pos = pos - 1
		else
			pos = pos + 1
		end

		if pos >= 100 then pos = 0 end
		if pos <= -1 then pos = 99 end
		if pos == 0 then clicks_past = clicks_past + 1 end
	end

	if pos == 0 then lands_on = lands_on + 1 end
end

print("Part 1: " .. lands_on .. "\n" .. "Part 2: " .. clicks_past)

timer.stop = os.clock()
timer.diff = (timer.stop - timer.start) * 1000
print(timer.diff .. "ms")
