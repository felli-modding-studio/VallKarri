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
    "lib/rarities_types",
    "lib/overrides",

    "items/misc",
    "items/badges",
    "items/common_jokers",
    "items/uncommon_jokers",
    "items/tags",

    "items/leveling",
    "items/overscoring",
    "items/hand_buffs"
}
VALK.UTILS.load_table(_items)
VALK.LOADING.load()

--TODO: CTRL+F valk2 -> valk
--this is a temporary measure so i can have both mods in my folder at once

VALK.calculate = function(self, context)
    for i = 1, #G.GAME.tags do
        local c = G.P_TAGS[G.GAME.tags[i].key]
        if c.calculate then
            local ret = c:calculate(G.GAME.tags[i], context)
            if ret then
                for i2, v in pairs(ret) do
                    G.CARD_H = -G.CARD_H
                    SMODS.calculate_individual_effect(ret, G.GAME.tags[i].HUD_tag, i2, v)
                    G.CARD_H = -G.CARD_H
                end
            end
        end
    end
    if VALK.LEVELING.metacalc then
        VALK.LEVELING.metacalc(context)
    end
    if context.after then
        G.E_MANAGER:add_event(Event{
            func = function()
                G.GAME.buff_text = ""
                return true
            end
        })
    end
    if VALK.config.hand_buffs and context.final_scoring_step and next(G.GAME.applied_buffs) then
        local effects = {}
        for _,buff in ipairs(G.GAME.applied_buffs) do
            if VALK.BUFFS.hand_buff_functions[buff.key] then
                effects = SMODS.merge_effects({effects, VALK.BUFFS.hand_buff_functions[buff.key](buff.power, G.play.cards) or {}})
            end
        end
        SMODS.calculate_effect(effects, G.deck.cards[1] or G.deck)
    end
end