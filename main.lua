VALK = SMODS.current_mod

--This will do error handling for loading the utils and loading file
--All other file loading is handled by utils
local function _load(p)
    local f, err = SMODS.load_file(p)
    if err then error(err) else f() end
end

_load("lib/utils.lua")
_load("lib/loading.lua")

local _items = {

    "lib/atlas",

    "items/misc",
    "items/badges",
    "items/common_jokers"
}
VALK.UTILS.load_table(_items)
VALK.LOADING.load()

--TODO: CTRL+F valk2 -> valk
--this is a temporary measure so i can have both mods in my folder at once