-- i'm not making these configurable ingame
-- sorry!

function config_reset()
    G.GAME.ante_config = {
        limit = 32
    }
end

VALK.OVERSCORING = {}

local easeantecopy = ease_ante
function ease_ante(x)
    -- print("starting")

    x = to_number(x)

    if (x < 1) or (not VALK.config.overscoring) then
        easeantecopy(to_number(x))
        return
    end

    if (G.GAME.ante_gain_multiplier) then
        x = x * G.GAME.ante_gain_multiplier
    end
    -- print(G.GAME.chips and G.GAME.blind.chips)

    if (G.GAME.chips and G.GAME.blind.chips) then
        local anteChange = VALK.OVERSCORING.get_ante_change()
        anteChange = math.ceil(anteChange)
        VALK.OVERSCORING.display_ante_changes(anteChange)
        easeantecopy(x)
        VALK.OVERSCORING.add_effective_ante_mod(to_number(anteChange), "+")

        return
    end

    easeantecopy(x)
end

function VALK.OVERSCORING.display_ante_changes(change)
    if (change == 0) then
        return
    end

    local str = "Overscored! +" .. change .. " ante."

    local overscore_sound = change > 4 and "overscore_harsh" or "overscore_light"

    G.E_MANAGER:add_event(Event({
        func = (function()
            play_sound("valk2_"..overscore_sound)
            attention_text({
                scale = 1,
                text = str,
                hold = 2*math.max(G.SETTINGS.GAMESPEED / 2, 1),
                colour = G.C.RED,
                align = 'cm',
                offset = { x = 0, y = -2.7 },
                major = G.play
            })
            return true
        end)
    }))


    return
end

function VALK.OVERSCORING.get_ante_change(theoretical_score, debug)
    local win_pot = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)
    local ovsc = overscore_threshhold()
    win_pot = (theoretical_score and to_big(theoretical_score)) or win_pot

    if to_big(win_pot) < to_big(ovsc) then
        return 0
    end

    win_pot = to_big(win_pot)

    local anteChange = 0
    local theochange = to_big(0)
    local inc = 1
    while theochange < win_pot do
        anteChange = math.floor(anteChange + inc)
        inc = inc * 1.1
        theochange = to_big(get_blind_amount(anteChange + G.GAME.round_resets.ante))
        -- print(anteChange, theochange)
    end

    return math.max(anteChange ^ 0.6, anteChange / 2)
end

function overscore_threshhold()
    local change = G.GAME.overscoring_threshold_base or 10
    return get_blind_amount(change + G.GAME.round_resets.ante)
end

local fakeupd = Game.update

function Game:update(dt)
    fakeupd(self, dt)

    if (G.GAME.blind and G.GAME.ante_config) then
        if (G.GAME.blind.boss) then
            local num = number_format(overscore_threshhold())
            G.GAME.blind.overchips = VALK.config.overscoring and ("Overscoring at " .. num) or
            "Overscoring Disabled"
        else
            G.GAME.blind.overchips = ""
        end
    end
    if G.GAME.round_resets.eante_ante_diff and G.GAME.round_resets.eante_ante_diff ~= 0 then
        G.GAME.round_resets.eante_disp = "(" ..
            number_format(G.GAME.round_resets.eante_ante_diff + G.GAME.round_resets.ante) .. ")"
    else
        G.GAME.round_resets.eante_disp = ""
    end
end

local _create_UIBox_HUD_blind = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
    local ret = _create_UIBox_HUD_blind()


    -- if (not G.GAME.blind.boss) then
    --     return ret
    -- end
    if VALK.config.overscoring and G.GAME.blind_on_deck == "Boss" then
        local node = ret.nodes[2]
        node.nodes[#node.nodes + 1] = {
            n = G.UIT.R,
            config = { align = "cm", minh = 0.6, r = 0.1, emboss = 0.05, colour = G.C.DYN_UI.MAIN },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = "cm", minw = 3 },
                    nodes = {
                        {
                            n = G.UIT.O,
                            config = {
                                object = DynaText({
                                    string = { { ref_table = G.GAME.blind, ref_value = "overchips" } },
                                    colours = { G.C.UI.TEXT_LIGHT },
                                    shadow = true,
                                    float = true,
                                    scale = 0.27,
                                    y_offset = -4,
                                }),
                                id = "ante_overscoreText",
                            },
                        },
                    },
                },
            },
        }
    end
    return ret
end

function VALK.OVERSCORING.refresh_ante_diff()
    local ante = G.GAME.round_resets.ante
    local original_ante = ante

    G.GAME.run_ante_modifiers = G.GAME.run_ante_modifiers or {}
    for _, mod in pairs(G.GAME.run_ante_modifiers) do
        ante = (mod.o == "+" and (ante + mod.v)) or (mod.o == "*" and (ante * mod.v)) or
            (mod.o == "^" and (ante ^ mod.v)) or ante
    end

    ante = math.floor(ante)

    G.GAME.round_resets.eante_ante_diff = (ante - original_ante)
end

function VALK.OVERSCORING.add_effective_ante_mod(amount, operator)
    G.GAME.run_ante_modifiers[#G.GAME.run_ante_modifiers + 1] = { v = amount, o = operator }
    VALK.OVERSCORING.refresh_ante_diff()
end

local original_gba = get_blind_amount

function calc_blind_amount(ante)
    if ante <= (G.GAME.ante_config and G.GAME.ante_config.limit or 32) then
        return original_gba(ante)
    end

    if Talisman then
        -- print("ante size current calc:")
        -- print(number_format(gba(ante)) .. "{" .. number_format(math.floor(ante / 1500)) .. "}" .. number_format(gba(ante)))
        -- print("Expecting:" .. number_format(to_big(gba(ante)):arrow(math.floor(ante / 1500), to_big(gba(ante)))))
        return to_big(original_gba(ante)):arrow(math.floor(ante / 1500), to_big(original_gba(ante)))
    end

    return original_gba(ante) ^ original_gba(ante)
end

function get_blind_amount(ante)
    local original_ante = ante
    local to_remove = {}
    G.GAME.run_ante_modifiers = G.GAME.run_ante_modifiers or {}
    for _, mod in pairs(G.GAME.run_ante_modifiers) do
        ante = (mod.o == "+" and (ante + mod.v)) or (mod.o == "*" and (ante * mod.v)) or
            (mod.o == "^" and (ante ^ mod.v)) or ante
    end

    ante = math.floor(ante) --prevent issues with decimal antes

    VALK.OVERSCORING.refresh_ante_diff()

    return calc_blind_amount(ante)
end

SMODS.Sound {
    key = "overscore_harsh",
    path = "overscore.ogg"
}

SMODS.Sound {
    key = "overscore_light",
    path = "overscore_light.ogg"
}


VALK.UTILS.Back {
    key = "inertia",
    valk_artist = "Scraptake",
    pos = { x = 0, y = 1 },
    atlas = "misc",
    apply = function(self)
        G.GAME.ante_gain_multiplier = self.config.antegain
        G.GAME.overscoring_threshold_base = 2
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.antegain } }
    end,
    config = { antegain = 0.5 },
}
