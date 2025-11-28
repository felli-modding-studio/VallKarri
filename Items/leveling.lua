if not vallkarri.config.metaprogression then
    return
end

function vallkarri.calculate_power()
    local base = (G.GAME.current_level or 1) ^ 0.5

    -- ex.
    -- vallkarri.add_power_modifier(function(m) return m^2 end)

    local mfd = {}
    for i, tab in ipairs(vallkarri.run_power_modifiers) do
        -- tab = {run = func, store = storage, dest = destruction}
        local m, ret = tab.run(base, tab.store)
        base = m
        if ret then
            tab.store = ret
        end
        if tab.dest and tab.dest(tab.store) then
            table.insert(mfd, tab)
        end
    end

    for _, val in pairs(mfd) do
        local i = find_index(val, vallkarri.run_power_modifiers)
        if i then
            table.remove(vallkarri.run_power_modifiers, i)
        end
    end
    return base
end

function vallkarri.set_leveling_shader(_shader)
    if not G.HUD_META then
        return
    end

    G.HUD_META:get_UIE_by_ID("shader_insert").config.shader = _shader
    G.HUD_META:recalculate()
end

function create_UIBox_metaprog()
    local text_scale = 0.3
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05, colour = { 0.215, 0.258, 0.267, 1 }, r = 0.1 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "tl", colour = G.C.DYN_UI.BOSS_DARK, r = 0.1, minh = 0.25, minw = 3, padding = 0.08, id = "shader_insert" }, --shader go here
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    { n = G.UIT.T, config = { text = "Level ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { id = "curlvl_text", ref_table = G.GAME, ref_value = "current_level_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    { n = G.UIT.T, config = { id = "that_fucking_space_that_i_hate", text = "  ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    { n = G.UIT.T, config = { id = "buff", ref_table = G.GAME, ref_value = "xp_exponent_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale * 0.8, shadow = true, prev_value = "nil" } },
                                }
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cl", padding = 0.01, maxw = 2.7 },
                                nodes = {
                                    { n = G.UIT.T, config = { id = "curxp_text", ref_table = G.GAME, ref_value = "current_xp_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "curxp_text", ref_table = G.GAME.vallkarri.text_display, ref_value = "xp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { text = " / ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { id = "maxxp_text", ref_table = G.GAME, ref_value = "required_xp_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "maxxp_text", ref_table = G.GAME.vallkarri.text_display, ref_value = "req", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } }
                                },

                            },
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    -- { n = G.UIT.T, config = { text = "Power: ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale * 0.85, shadow = true } },
                                    -- { n = G.UIT.T, config = { id = "curpow_text", ref_table = G.GAME, ref_value = "valk_power", colour = G.C.UI.TEXT_LIGHT, scale = text_scale * 0.85, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "that_fucking_space_that_i_hate_2", text = " ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    { n = G.UIT.C, config = { button = "toggle_level_effects", colour = G.C.RED, minh = 0.175, minw = 1.2, r = 0.01 }, 
                                        nodes = {
                                            { n = G.UIT.T, config = { text = "See effects", colour = G.C.UI.TEXT_LIGHT, scale = text_scale * 0.85, shadow = true  } }
                                        }
                                    }
                                }

                            }
                        }
                    },


                }
            },


        }
    }
end

function create_UIBox_level_effects()
    local text_scale = 0.3
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05, colour = { 0.215, 0.258, 0.267, 1 }, r = 0.1 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "tl", colour = G.C.DYN_UI.BOSS_DARK, r = 0.1, minh = 0.25, minw = 3, padding = 0.08 },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01 },
                                nodes = {
                                    { n = G.UIT.T, config = { text = "Your level is currently giving:", colour = G.C.UI.TEXT_LIGHT, scale = text_scale * 1, shadow = true, prev_value = "nil" } },
                                }

                            },
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    { n = G.UIT.T, config = { id = "money_multiplier_text", ref_table = G.GAME, ref_value = "money_mod_disp", colour = G.C.MONEY, scale = text_scale * 0.85, shadow = true, prev_value = "nil" } },
                                }
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    { n = G.UIT.T, config = { id = "blindsize_multiplier_text", ref_table = G.GAME, ref_value = "blindsize_mod_disp", colour = G.C.ORANGE, scale = text_scale * 0.85, shadow = true, prev_value = "nil" } },
                                },

                            },
                            
                        }
                    },


                }
            },


        }
    }
end

function G.FUNCS.toggle_level_effects(e)
    local money = vallkarri.get_level_money_multiplier()
    local blindsize = vallkarri.get_level_blind_size_multiplier()
    G.GAME.money_mod_disp = "X" .. (type(money) == "number" and string.format("%.3f", money) or number_format(money)) .. " Money Gain"
    G.GAME.blindsize_mod_disp = "X" .. (type(blindsize) == "number" and string.format("%.3f", blindsize) or number_format(blindsize)) .. " Blind Size"


    G.GAME.level_effects_open = not G.GAME.level_effects_open
    G.HUD_LEVEL_EFFECTS.config.offset.x = G.ROOM.T.w + (G.GAME.level_effects_open and -2.2 or 500)
end

local upd = Game.update
function Game:update(dt)
    upd(self, dt)

    if G.GAME.current_level then
        G.GAME.current_level_disp = number_format(G.GAME.current_level)
    end

    if G.GAME.current_xp then
        G.GAME.current_xp_disp = number_format(G.GAME.current_xp)
    end

    if G.GAME.required_xp then
        G.GAME.required_xp_disp = number_format(G.GAME.required_xp)
    end
end

local fakestart = Game.start_run
function Game:start_run(args)
    -- print(args)
    fakestart(self, args)

    self.HUD_META = UIBox {
        definition = create_UIBox_metaprog(),
        config = { align = ('cli'), offset = { x = G.ROOM.T.w - 1, y = -2.15 }, major = G.ROOM_ATTACH }
    }

    self.HUD_LEVEL_EFFECTS = UIBox {
        definition = create_UIBox_level_effects(),
        config = { align = ('cli'), offset = { x = G.ROOM.T.w + 500, y = -0.85 }, major = G.ROOM_ATTACH }
    }
    if args.savetext then
        return
    end

    self.GAME.current_level = 1
    self.GAME.current_xp = 0
    self.GAME.required_xp = vallkarri.xp_required(G.GAME.current_level)
    self.GAME.valk_power = 1

    vallkarri.run_xp_modifiers = {}
    vallkarri.run_power_modifiers = {}



    
    self.GAME.level_effects_open = false
end

vallkarri.run_xp_modifiers = {}
vallkarri.run_power_modifiers = {}

---Add an xp modifier to the run, which can optionally be removed upon a destruction condition
---@param func function
---@param storage table
---@param destruction function
function vallkarri.add_xp_modifier(func, storage, destruction)
    vallkarri.run_xp_modifiers[#vallkarri.run_xp_modifiers + 1] = { run = func, store = storage or {}, dest = destruction }
end

---Add a power modifier to the run, which can optionally be removed upon a destruction condition
---@param func function
---@param storage table
---@param destruction function
function vallkarri.add_power_modifier(func, storage, destruction)
    vallkarri.run_power_modifiers[#vallkarri.run_power_modifiers + 1] = { run = func, store = storage or {}, dest =
    destruction }
end

function vallkarri.get_base_xp_exponent()
    return (G.GAME.stake ^ 0.25) * (1 + (G.GAME.round / 100))
end

-- gets the xp required for the specified level


function vallkarri.mod_level(amount, from_xp)
    local req = vallkarri.xp_required(G.GAME.current_level)
    G.GAME.current_level = G.GAME.current_level + amount

    G.HUD_META:get_UIE_by_ID("curlvl_text"):juice_up()
    G.HUD_META:get_UIE_by_ID("maxxp_text"):juice_up()

    G.GAME.required_xp = vallkarri.xp_required(G.GAME.current_level)
    if from_xp then
        G.GAME.current_xp = G.GAME.current_xp - req
    end
end

local compress_events = false
local active_xp_queue = 0
local xp_queued = 0
function vallkarri.mod_xp(mod, relevant_card)
    local thresh = 128
    if (not Talisman or (Talisman and not Talisman.config_file.disable_anims)) and active_xp_queue < thresh then --prevent excessive retriggers or whatever from causing problems
        active_xp_queue = active_xp_queue + 1
        -- print("+1 event, now " .. active_xp_queue)
        G.E_MANAGER:add_event(Event({
            func = function()
                vallkarri.animationless_mod_xp(mod)

                G.HUD_META:get_UIE_by_ID("curxp_text"):juice_up()

                if relevant_card and relevant_card.juice_up then
                    relevant_card:juice_up()
                end


                active_xp_queue = active_xp_queue - 1
                -- print("-1 event, now " .. active_xp_queue)
                return true
            end,

        }), active_xp_queue < thresh / 2 and nil or 'other')
    else
        -- emergency optimization
        -- print("!!QUEUEING SLOWLY")
        if compress_events then
            xp_queued = xp_queued + mod
        else
            vallkarri.animationless_mod_xp(mod)
        end
    end
end

function vallkarri.reset_levels()
    G.GAME.current_level = 1
    G.GAME.current_xp = 0
    G.GAME.required_xp = vallkarri.xp_required(G.GAME.current_level)
end

function vallkarri.metacalc(context)
    G.GAME.xp_exponent_disp = "(^" .. vallkarri.get_base_xp_exponent() .. " XP)"
    G.GAME.valk_power = vallkarri.calculate_power()

    if context.end_of_round and context.main_eval then
        local overscore_margin = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)
        G.GAME.hypercap_level = G.GAME.hypercap_level or 1
        vallkarri.mod_xp(vallkarri.hypercap(overscore_margin, G.GAME.current_level^2))
    end
end

function vallkarri.animationless_mod_xp(mod)
    -- stake mods
    mod = mod ^ vallkarri.get_base_xp_exponent()

    if type(G.GAME.current_xp) == "table" then
        G.GAME.required_xp = to_big(G.GAME.required_xp)
    end

    if type(G.GAME.required_xp) == "table" then
        G.GAME.current_xp = to_big(G.GAME.current_xp)
    end

    local mfd = {}
    for i, tab in ipairs(vallkarri.run_xp_modifiers) do
        -- tab = {run = func, store = storage, dest = destruction}
        local m, ret = tab.run(mod, tab.store)
        mod = m
        if ret then
            tab.store = ret
        end
        if tab.dest and tab.dest(tab.store) then
            table.insert(mfd, tab)
        end
    end

    for _, val in pairs(mfd) do
        local i = find_index(val, vallkarri.run_xp_modifiers)
        if i then
            table.remove(vallkarri.run_xp_modifiers, i)
        end
    end

    G.GAME.current_xp = G.GAME.current_xp + mod

    vallkarri.xp_safety_check()

    G.GAME.current_xp = math.floor(G.GAME.current_xp)
    G.GAME.required_xp = math.floor(G.GAME.required_xp)

    -- if to_big(G.GAME.current_xp) > to_big(G.GAME.required_xp) * 16 then
    --     vallkarri.mod_level(math.floor(vallkarri.xp_to_level(G.GAME.current_xp +
    --     vallkarri.level_to_xp(G.GAME.current_level)) - G.GAME.current_level))
    --     G.GAME.current_xp = 0
    -- end


    while to_big(G.GAME.current_xp) >= to_big(G.GAME.required_xp) do
        vallkarri.mod_level(1, true)
    end
end

function vallkarri.xp_safety_check()
    G.GAME.current_xp = to_big(G.GAME.current_xp) or 0
    G.GAME.required_xp = to_big(G.GAME.required_xp) or 0
    G.GAME.current_level = to_big(G.GAME.current_level) or 1
end

function vallkarri.xp_required(level)
    level = to_number(level)

    local req = 100 * level

    return to_number(req)
end

local easemoneyhook = ease_dollars
function ease_dollars(mod, x)
    if to_big(mod) > to_big(0) then
        local multiplier = vallkarri.get_level_money_multiplier()
        local final = mod * multiplier
        final = math.max(math.floor(final), mod)
        easemoneyhook(final, x)
    else
        easemoneyhook(mod, x)
    end

    if to_big(mod) < to_big(0) then
        vallkarri.mod_xp(-mod*2)
    end
end

local easeantehook = ease_ante
function ease_ante(x)
    easeantehook(x)

    if x > 0 then
        vallkarri.mod_xp(25 * x * G.GAME.round_resets.ante)
    end
end

local levelhandhook = level_up_hand
function level_up_hand(card, hand, instant, amount)
    levelhandhook(card, hand, instant, amount)

    if to_big(amount or 1) > to_big(0) then
        vallkarri.mod_xp(math.log(amount or 1, 2) * 25, card)
    end
end

local blindamounthook = get_blind_amount

function get_old_blind_amount(ante)
    return blindamounthook(ante)
end

function vallkarri.get_level_money_multiplier()
    return math.min(G.GAME.current_level ^ 0.02, G.GAME.money_mult_cap or 3)
end

function vallkarri.get_level_blind_size_multiplier(ante)
    ante = ante or G.GAME.round_resets.ante
    G.GAME.current_level = G.GAME.current_level or 1
    return math.min(G.GAME.current_level ^ 0.02, (G.GAME.round+1)^2)
end

function get_blind_amount(ante)
    local amount = blindamounthook(ante)
    local multiplier = vallkarri.get_level_blind_size_multiplier(ante)
    -- print(multiplier .. " at level " ..  (G.GAME.current_level or 0))
    amount = amount * multiplier

    if to_big(amount) > to_big(10 ^ 308) then
        return amount
    end

    local nearest = math.floor(math.log10(amount)) - 1
    -- round to 2 sigfigs
    nearest = 10 ^ nearest
    return math.floor((amount / nearest) + 0.5) * nearest

    -- x1+(0.02*ante) ^ 1+(0.2*level)
end

local amt = 1
SMODS.Voucher {
    key = "alphaboosterator",
    atlas = "main",
    pos = { x = 2, y = 7 },
    loc_txt = {
        name = "Alpha XP Boosterator",
        text = {
            "{X:dark_edition,C:white}X#1#{} to all XP gain",
            -- "{C:inactive}(Can spawn and be redeemed multiple times)",
            "{C:inactive}(XP Boosterators apply in the order they were obtained)",
        }
    },
    no_doe = true,
    config = { extra = { xp = 1.9 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xp } }
    end,
    redeem = function(self, card)
        vallkarri.add_xp_modifier(function(x, t) return x * card.ability.extra.xp end)
    end,



}


SMODS.Voucher {
    key = "betaboosterator",
    atlas = "main",
    pos = { x = 3, y = 7 },
    loc_txt = {
        name = "Beta XP Boosterator",
        text = {
            "{X:dark_edition,C:white}^#1#{} to all XP gain",
            -- "{C:inactive}(Can spawn and be redeemed multiple times)",
            "{C:inactive}(XP Boosterators apply in the order they were obtained)",
        }
    },
    no_doe = true,
    config = { extra = { xp = 1.09 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xp } }
    end,
    redeem = function(self, card)
        vallkarri.add_xp_modifier(function(x, t) return x ^ card.ability.extra.xp end)
    end,



}

SMODS.Voucher {
    key = "gammaboosterator",
    atlas = "main",
    pos = { x = 4, y = 7 },
    loc_txt = {
        name = "Gamma XP Boosterator",
        text = {
            "{X:dark_edition,C:white}^#1#{} to all XP gain",
            -- "{C:inactive}(Can spawn and be redeemed multiple times)",
            "{C:inactive}(XP Boosterators apply in the order they were obtained)",
        }
    },
    no_doe = true,
    config = { extra = { xp = 1.9 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xp } }
    end,
    redeem = function(self, card)
        vallkarri.add_xp_modifier(function(x, t) return x ^ card.ability.extra.xp end)
    end,



}
