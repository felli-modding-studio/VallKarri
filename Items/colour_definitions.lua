vallkarri.custom_colours = {
	VALK_PRESTIGIOUS = { HEX("60f542"), HEX("5efaff") },
	VALK_PRESTIGIOUS_LIGHTER = { HEX("A5FF93"), HEX("A1FCFF") },
	VALK_UNPLEASANT = { HEX("22d71d"), HEX("7a9374"), HEX("fd2ef6"), HEX("c24462"), HEX("9b5300"), },
	VALK_RENOWNED = { HEX("FF6FF8"), HEX("7810FF") },
	VALK_EXQUISITE = { HEX("2B2EFF"), HEX("62EDFF"), HEX("0061CF") },
	VALK_FIRE = { HEX("FF802B"), HEX("FFDE26"), HEX("FF4314") },
	VALK_BLUE = { HEX("2848FF"), HEX("6AC8FF") },
	VALK_SCP = { HEX("6CE746"), HEX("F1E64B"), HEX("F01212") },
	VALK_GAY = { HEX("058f6e"), HEX("24ceaa"), HEX("99e8c0"), HEX("ffffff"), HEX("7bade3"), HEX("4e49cb"), HEX("401a76") },
	VALK_GURPLE = { HEX("558BFF"), HEX("CD7AF3"),  },
}

local updhook = Game.update

for name, color in pairs(vallkarri.custom_colours) do
	G.C[name] = { 0, 0, 0, 0 }
end
function Game:update(dt)
	updhook(self, dt)
	--copied from cryptid, basically.
	-- sowwy :(
	local anim_timer = self.TIMERS.REAL * 1.5
	local p = 0.5 * (math.sin(anim_timer) + 1)
	for k, c in pairs(vallkarri.custom_colours) do
		local n = #c
		if n ~= 0 then
			if not G.C[k] then
				G.C[k] = { 0, 0, 0, 0 }
			end
			-- Slow down interpolation based on number of colors
			local speed = 1 / (1 + 0.5 * (n - 2))
			local t = (p * speed) * (n - 1)
			local idx = math.floor(t) + 1
			local frac = t - math.floor(t)
			local c1 = c[idx]
			local c2 = c[math.min(idx + 1, n)]
			for i = 1, 4 do
				G.C[k][i] = c1[i] * (1 - frac) + c2[i] * frac
			end
		end
	end

	for name, colors in pairs(vallkarri.custom_colours) do
		if G.C.RARITY[string.lower(name)] then
			G.C.RARITY[string.lower(name)] = G.C[name]
		end
	end
end

local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end
	for name, colors in pairs(vallkarri.custom_colours) do
		G.ARGS.LOC_COLOURS[string.lower(name)] = G.C[name]
	end
	return lc(_c, _default)
end

-- ^^0.01 for each played card
