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