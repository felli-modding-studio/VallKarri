if not VALK.config.hand_buffs then
    return
end

local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)
    G.GAME.buff_text = ""

    G.GAME.existing_buffs = VALK.BUFFS.hand_buffs
    G.GAME.buff_power = {}
    for name, _ in pairs(G.GAME.existing_buffs) do
        G.GAME.buff_power[name] = 0
    end
end

VALK.BUFFS = {}
VALK.BUFFS.hand_buffs = {
    m_bonus = { title = "EXTRA", colour = G.C.CHIPS },
    m_mult = { title = "MULTI", colour = G.C.MULT },
    m_wild = { title = "WILD", colour = VALK.UTILS.lerp_c(G.C.RED, G.C.MONEY, 20) },
    m_gold = { title = "GILDED", colour = G.C.MONEY },
    m_lucky = { title = "CHANCE", colour = G.C.GREEN },
    m_glass = { title = "SHATTERED", colour = G.C.WHITE },
    m_steel = { title = "FORGED", colour = G.C.GREY },
    m_stone = { title = "CRACKED", colour = darken(G.C.GREY, 5) },
    m_cry_echo = { title = "ECHOING", colour = G.C.PURPLE },
    m_cry_light = { title = "GLOWING", colour = G.C.YELLOW },
    m_cry_abstract = { title = "ABSTRACTED", colour = G.C.CRY_ASCENDANT },
}

VALK.BUFFS.hand_buff_functions = {
    m_bonus = function(n) return { sound = "valk_buff_bonus", xchips = (1 + n) ^ 1.25 } end,
    m_mult = function(n) return { sound = "valk_buff_mult", xmult = (1 + n) ^ 1.25 } end,
    m_wild = function(n, cards)
        local t = VALK.BUFFS.get_hand_buff_functions()
        return SMODS.merge_effects({ pseudorandom_element(t, "m_wild_buff")(n, cards), pseudorandom_element(t,
            "m_wild_buff")(n, cards), { sound = "valk_buff_wild", } })
    end,
    m_gold = function(n) return { sound = "valk_buff_gold", dollars = math.ceil((3 + n) ^ 1.1) } end,
    m_lucky = function(n)
        n = n + 1
        return {
            sound = "valk_buff_lucky",
            chips = pseudorandom("chance", 1, n ^ 2),
            mult = pseudorandom("chance", 1, n ^ 2),
            xchips = pseudorandom("chance", 1, n ^ 0.5),
            xmult = pseudorandom("chance", 1, n ^ 0.5)
        }
    end,
    m_glass = function(n) return { sound = "valk_buff_glass", emult = (n + 1) ^ 1.15 } end,
    m_steel = function(n) return { sound = "valk_buff_steel", emult = (n + 3) ^ 1.05 } end,
    m_stone = function(n) return { echips = 1 + ((n ^ 0.7) / 2) } end,
}
function VALK.BUFFS.add_hand_buff(key, title, colour, scoring_func)
    if VALK.BUFFS.hand_buffs[key] then
        if VALK.BUFFS.hand_buffs[key].title == "FAR-FLUNG" then
            sendTraceMessage("Overwriting default hand buff for cross-mod enhancement " ..
                key, "Vall-Karri")
        elseif VALK.BUFFS.hand_buffs[key].title ~= title then
            sendWarnMessage(
                "Overwriting hand buff for cross-mod enhancement " .. key .. ", this might not be what you wanted to do?",
                "Vall-Karri")
        end
    end
    VALK.BUFFS.hand_buffs[key] = { title = title, colour = colour }
    VALK.BUFFS.hand_buff_functions[key] = scoring_func
    if G and G.GAME then
        G.GAME.existing_buffs = VALK.BUFFS.hand_buffs
        G.GAME.buff_power[key] = 0
    end
end

function VALK.BUFFS.populate_crossmod_buffs()
    local sancheck = false
    for k, v in pairs(SMODS.Centers) do
        if v.set and v.set == "Enhanced" and not VALK.BUFFS.hand_buffs[v.key] then
            sancheck = true
            --sendDebugMessage("found unbuffed enhancement "..v.key, "Vall-Karri")
            if v.valk_hand_buff then
                if type(v.valk_hand_buff) == "table" then
                    local title = v.valk_hand_buff.title
                    local colour = v.valk_hand_buff.colour or v.valk_hand_buff.color
                    local scoring_func = v.valk_hand_buff.scoring_func
                    if (title and colour and scoring_func) then
                        VALK.BUFFS.add_hand_buff(k, title, colour, scoring_func)
                    else
                        sendWarnMessage("Hand buff definition for " ..
                            k ..
                            " from " ..
                            ((v.original_mod or v.mod).name or "some mod that's doing a weird") ..
                            " seems incorrectly formed; check your code please")
                    end
                end
            else
                VALK.BUFFS.add_hand_buff(v.key, "FAR-FLUNG", HEX("ABCDEF"), function(n)
                    local ratio = (n + 4) / 5
                    return { --Deliberately kinda meh
                        sound = "valk_buff_wild",
                        chips = pseudorandom("far-flung", 1, n ^ 2),
                        mult = pseudorandom("far-flung", 1, n ^ 2),
                        xchips = 1 + (math.floor((pseudorandom("far-flung") * ratio) * 100) / 100),
                        xmult = 1 + (math.floor((pseudorandom("far-flung") * ratio) * 100) / 100),
                        dollars = pseudorandom("far-flung", 1, n)
                    }
                end)
            end

            --v.valk_hand_buff and type(v.valk_hand_buff) == "function"
        end
    end
    if sancheck == false then sendDebugMessage("all buffs populated already", "Vall-Karri") end
end

local uhthook = update_hand_text
function update_hand_text(config, vals)
    uhthook(config, vals)

    local enhancements = {}
    for i, card in ipairs(#G.hand.highlighted > 0 and G.hand.highlighted or G.play.cards) do
        for key, enhancement in pairs(SMODS.get_enhancements(card)) do
            enhancements[#enhancements + 1] = key
        end
    end

    local counts = {}
    for i, enh in ipairs(enhancements) do
        if G.GAME.existing_buffs[enh] then
            if not counts[enh] then
                counts[enh] = 1
            else
                counts[enh] = counts[enh] + 1
            end
        end
    end

    for name, pow in pairs(G.GAME.buff_power) do
        counts[name] = counts[name] and counts[name] + pow or pow
    end

    -- string is build like +NAME+2xNAME+3xNAME
    -- not in order of number
    local str = ""
    local colour = nil
    G.GAME.applied_buffs = {}
    G.GAME.buff_requirement = G.GAME.buff_requirement or 5
    for name, count in pairs(counts) do
        local pwr = count - (G.GAME.buff_requirement - 1)
        if pwr > 0 then
            str = str .. " + " .. ((pwr > 1) and (pwr .. "x") or "") .. G.GAME.existing_buffs[name].title
            G.GAME.applied_buffs[#G.GAME.applied_buffs + 1] = {
                power = pwr,
                effect = G.GAME.existing_buffs[name],
                key = name
            }
        end
    end

    for name, val in pairs(G.GAME.existing_buffs) do
        if counts[name] > 0 then
            colour = val.colour
        end
    end

    if not next(G.GAME.applied_buffs) then
        G.GAME.buff_text = ""
        return
    end

    if not colour then
        -- how did we get here?
        return
    end
    G.E_MANAGER:add_event(Event({ --Hello LocalThunk --LocalThunk: Hello
        trigger = 'before',
        blockable = not config.immediate,
        delay = config.delay or 0.8,
        func = function()
            local old = G.GAME.buff_text
            G.GAME.buff_text = str
            if G.GAME.buff_text ~= old then
                G.HUD:get_UIE_by_ID("bufftext"):juice_up()
            end
            G.HUD:get_UIE_by_ID("bufftext").config.colour = colour
            return true
        end
    }))
end

local hudcopy = create_UIBox_HUD
function create_UIBox_HUD(force)
    local res = hudcopy()
    res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[4] = {
        n = G.UIT.R,
        config = { align = "cm", minh = 0.5 },
        nodes = { {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = {
                { n = G.UIT.T, config = { id = "bufftext", ref_table = G.GAME, ref_value = "buff_text", scale = 0.3, colour = G.C.WHITE, shadow = true } },
            }
        } }
    }

    return res
end

function VALK.BUFFS.get_hand_buff_functions()
    -- this functions name is intentionally long and stupid
    return VALK.BUFFS.hand_buff_functions
end