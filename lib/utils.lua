VALK.UTILS = {}

VALK.UTILS.load_file = function(path)
    local f, err = SMODS.load_file(path..".lua")
    if err then error(err) else f() end
end

VALK.UTILS.load_table = function(table)
    for i, v in pairs(table) do VALK.UTILS.load_file(v) end
end

--These functions will facilitate arbitrary ordering across files
VALK.UTILS.add_content = function(tbl, set)
    if not tbl.object_type then tbl.object_type = set end
    VALK.LOADING.objects[set] = VALK.LOADING.objects[set] or {}
    VALK.LOADING.objects[set][#VALK.LOADING.objects[set]+1] = tbl
    return tbl
end

local _loading_funcs = {
    "Joker",
    "Consumable",
    "Tag",
    "Edition",
    "Back",
    "Sleeve",
    "Blind",
    "Voucher"
}
for i, v in pairs(_loading_funcs) do
    VALK.UTILS[v] = function(tbl) return VALK.UTILS.add_content(tbl, v) end
end

VALK.MISC = {
    credited_artists = {}
}
VALK.UTILS.credit = function(name, type)
    if type == "artist" then
        VALK.MISC.credited_artists[name] = VALK.MISC.credited_artists[name] or {}
        return ('{C:dark_edition,s:0.6,E:2}'..localize("k_art_by")..' : ' .. name .. '{}')
    elseif type == "shader" then
        return ('{C:dark_edition,s:0.6,E:2}'..localize("k_shader_by")..' : ' .. name .. '{}')
    elseif type == "cat" then
        return ('{C:dark_edition,s:0.6,E:2}'..localize("k_cat_by")..' : ' .. name .. '{}')
    end
end

VALK.UTILS.count_kitty_tags = function()
    local c = 0
    for i, tag in ipairs(G.GAME.tags or {}) do
        if tag.key == "tag_valk2_kitty" then
            c = c + 1
        end
    end
    return c
end

function VALK.UTILS.hypercap(n, cap)
    local initial_cap = cap
    local initial_n = n
    local run = to_big(n) > to_big(cap)
    local i = 1
    local limit = 100
    while run and i < limit do
        local exponent = 0.95 ^ i
        local oldcap = cap
        if Talisman and i > (limit / 10) then
            local arrows = math.floor(i ^ 0.5)
            n = to_big(n):arrow(arrows, exponent)
            --talisman broken :wilted_rose: so it also does htis too
            n = n ^ (0.5 ^ i)
        else
            n = n ^ exponent
        end
        cap = cap + (cap / 20)
        i = i + 1

        -- print(oldcap .. "->" .. cap)
        -- print(n .. "^" .. exponent .. ">" .. cap)

        run = to_big(n) > to_big(cap)
    end

    return math.max(n, math.min(initial_n, initial_cap))
end

function VALK.UTILS.lerp_c(c1, c2, percent)
    local new = {}

    if not lerp then
        return { (c1[1] + c2[1]) / 2, (c1[2] + c2[2]) / 2, (c1[3] + c2[3]) / 2, 1 }
    end

    new[1] = lerp(c1[1], c2[1], math.log10(percent / 10)) --strange, i know.
    new[2] = lerp(c1[2], c2[2], math.log10(percent / 10))
    new[3] = lerp(c1[3], c2[3], math.log10(percent / 10))
    return { new[1], new[2], new[3], 1 }
end