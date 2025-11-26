function credit(artist)
    vallkarri.credited_artists[artist] = vallkarri.credited_artists[artist] or {}
    return ('{C:dark_edition,s:0.6,E:2}Art by : ' .. artist .. '{}')
end

function shadercredit(shader_artist)
    return ('{C:dark_edition,s:0.6,E:2}Shader by : ' .. shader_artist .. '{}')
end

function catby(cat_owner)
    return ('{C:dark_edition,s:0.6,E:2}Cat by : ' .. cat_owner .. '{}')
end

function days_since(year, month, day)
    local now = os.date("*t")
    local then_time = os.time({ year = year, month = month, day = day, hour = 0 })
    local diff = os.difftime(os.time(now), then_time)
    return math.floor(diff / (60 * 60 * 24))
end

function quote(character)
    -- assume character is in quotes because i'm not a fucking idiot
    local quotes = {
        illena = "i'm here to help, nothing better to do.",
        quilla = "My name is pronounced \"Key-uh\"",
        quilla2 = "seriously, stop getting it wrong.",
        niko = "sorry im not wearing the twink bowtie :c",
        orivander = "Behold, the absolute force of gravity",
        raxd = "NUCLEAR BOMB!??!?!?",
        femtanyl = "we r online. we r online.",
        lilac = "A medium iced cappuccino, p-please.",
        ovilidoth = "",
        dormant = "I'm missing something.",
        dormant2 = "Help me find it and I'll make it worth your time.",
        scraptake = "good kitty",
        hornet = "silksong OUT NOW!!!",
        valklua = "Thank you for playing <3",
        phicer = "Who would've known I'd be cursed to see these cards again?"
    }

    return ('{C:enhanced,s:0.7,E:1}' .. quotes[character] .. '{}')
end

function times_used(key)
    for name, card in pairs(G.GAME.consumeable_usage) do
        if name == key then return card.count end
    end
    return 0
end

-- simplified code from jenlib

function basic_text_announce(txt, duration, size, col, snd, sndpitch, sndvol)
    G.E_MANAGER:add_event(Event({
        func = (function()
            if snd then play_sound(snd, sndpitch, sndvol) end
            attention_text({
                scale = size or 1.4,
                text = txt,
                hold = duration or 2,
                colour = col or G.C.WHITE,
                align = 'cm',
                offset = { x = 0, y = -2.7 },
                major =
                    G.play
            })
            return true
        end)
    }))
end

function vallkarri.quick_hand_text(name, chip, mul, lv, notif, snd, vol, pit, de)
    update_hand_text(
        {
            sound = type(snd) == 'string' and snd or type(snd) == 'nil' and 'button',
            volume = vol or 0.7,
            pitch = pit or 0.8,
            delay =
                de or 0.3
        }, {
            handname = name or '????',
            chips = chip or '?',
            mult = mul or '?',
            level = lv or '?',
            StatusText =
                notif
        })
end

function vallkarri.simple_hand_text(hand, notify)
    if hand == 'all' or hand == 'allhands' or hand == 'all_hands' then
        vallkarri.quick_hand_text(localize('k_all_hands'), '...', '...', '', notify)
    elseif G.GAME.hands[hand] then
        vallkarri.quick_hand_text(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips, G.GAME.hands[hand].mult,
            G.GAME.hands[hand].level, notify)
    end
end

function ratiocalc(a, b, c, d)
    local larger = math.max(a, b)
    local smaller = math.min(a, b)

    return ((smaller / larger) ^ c) * d
end

function vallkarri.get_most_played_hand()
    local name = nil
    local timesplayed = -1

    for i, hand in pairs(G.GAME.hands) do
        if hand.played > timesplayed then
            name = i
            timesplayed = hand.played
        end
    end

    return name
end

function math.map(v, imi, ima, omi, oma)
    return (v - imi) * (oma - omi) / (ima - imi) + omi
end

function vallkarri.multiply_all_hand_scaling(amt)
    for i, hand in pairs(G.GAME.hands) do
        G.GAME.hands[i].l_chips = G.GAME.hands[i].l_chips * amt
        G.GAME.hands[i].l_mult = G.GAME.hands[i].l_mult * amt
    end
end

function table:vcontains(table, value)
    for i, j in ipairs(table) do
        if (j == value) then return true end
    end
    return false
end

function table:superset(t_a, t_b)
    local valid = true

    for i, j in ipairs(t_b) do
        valid = valid and table:vcontains(t_a, j)
    end
    return valid
end

function destroy_first_instance(key)
    local found = SMODS.find_card(key)
    if #found > 0 then
        (select(2, next(found))):quick_dissolve()
    end
end

function joker_owned(key)
    if (G.jokers and G.jokers.cards) then
        for i, card in ipairs(G.jokers.cards) do
            if (card.config.center.key == key) then return true end
        end
    end

    return false
end

function quick_card_speak(card, text, wait)
    card_eval_status_text(card, 'extra', nil, nil, nil, { message = text, delay = wait })
end

function pause_event(time)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        timer = 'REAL',
        delay = time or 1,
        func = function()
            return true
        end
    }))
end

function debug_print_antes()
    local ante = 1
    local i = 1
    local i2 = 1
    while ante < 1e300 do
        local blind_amount = tostring(get_blind_amount(ante) or "nil")
        print("Ante " .. ante .. ": " .. blind_amount)

        if (ante > 15) then
            ante = ante * 1e10
        else
            ante = ante + i
        end
    end
end



-- i take no credit for these functions, theyre just slightly modified
-- versions of jenlib functions, as i don't like the text color which jenlib uses
function expochips(txt)
    return "{X:dark_edition,C:white}^" .. txt .. "{}"
end

function expomult(txt)
    return "{X:dark_edition,C:white}^" .. txt .. "{}"
end

-- chips and mult are identical since it uses x:dark

function reptlog(base, lim, num)
    for i = 1, lim do
        num = math.log(num, base)
    end

    return num
end

function get_first(area)
    return select(2, next(area))
end

function run_debug()
    assert(SMODS.load_file("debug.lua", "vallkarri"))()
end

function valk_additions()
    local total = 0
    for _, entry in pairs(G.P_CENTERS) do
        if string.find(entry.key, "valk") then
            total = total + 1
        end
    end

    return total
end

function level_all_hands(source, amount, mul)
    if amount == nil then
        amount = 1
    end

    if mul == nil then
        mul = 0
    end

    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
        { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if source then source:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))

    update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.9,
        func = function()
            play_sound('tarot1')
            if source then source:juice_up(0.8, 0.5) end
            return true
        end
    }))
    update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.9,
        func = function()
            play_sound('tarot1')
            if source then source:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = nil
            return true
        end
    }))
    local text = amount > 0 and "+" .. amount or amount
    if mul ~= 0 then
        text = "x" .. (mul + 1)
    end

    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = text })

    delay(1.3)
    for k, v in pairs(G.GAME.hands) do
        level_up_hand(source, k, true, amount + (v.level * mul))
    end
    update_hand_text({ delay = 0 }, { mult = 0, chips = 0, handname = '', level = '' })
end

function disable_mult_ui()
    G.GAME.mult_disabled = true
    if G.HUD:get_UIE_by_ID("chipmult_op") then G.HUD:get_UIE_by_ID("chipmult_op").UIT = 0 end
    G.HUD:get_UIE_by_ID("hand_mult_area").UIT = 0
    G.HUD:get_UIE_by_ID("hand_mult").UIT = 0
    G.HUD:get_UIE_by_ID("flame_mult").UIT = 0
    G.HUD:get_UIE_by_ID("hand_chip_area").config.minw = 4
    G.HUD:get_UIE_by_ID("hand_mult_area").config.minw = 0
    G.HUD:get_UIE_by_ID("hand_mult_area").config.minh = 0
    if G.HUD:get_UIE_by_ID("chipmult_op") then G.HUD:get_UIE_by_ID("chipmult_op").scale = 0 end

    G.HUD:recalculate()
end

function qdvi(val, growth, arrows)
    for i, card in ipairs(G.jokers.cards) do
        Cryptid.manipulate(card, { value = val })
    end
end

function find_index(card, list)
    if not list then --extremely niche case
        return false
    end
    for i, c in ipairs(list) do
        if c == card then
            return i
        end
    end
    return false
end

function draw_to_hand(cardlist)
    for i, card in ipairs(cardlist) do
        draw_card(card.area, G.hand, nil, nil, nil, card)
    end
end

function enhanced_in_deck(enhancement)
    if not G.playing_cards then
        return 0
    end
    local count = 0
    for i, card in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(card, enhancement) then
            count = count + 1
        end
    end

    return count
end

function Card:deselect()
    self.area:remove_from_highlighted(self)
end

function vallkarri.do_while_flipped(cards, func) --mostly borrowed from entropy, thank you ruby <3
    if not Talisman or (Talisman and not Talisman.config_file.disable_anims) then
        for i, _ in ipairs(cards) do
            local card = cards[i]
            if card then
                G.E_MANAGER:add_event(
                    Event(
                        {
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                if card.flip then
                                    card:flip()
                                end
                                return true
                            end
                        }
                    )
                )
            end
        end
    end
    for i, _ in ipairs(cards) do
        local card = cards[i]
        if card then
            G.E_MANAGER:add_event(
                Event(
                    {
                        trigger = "after",
                        delay = 0.15,
                        func = function()
                            func(card, cards, i)
                            return true
                        end
                    }
                )
            )
        end
    end
    if not Talisman or (Talisman and not Talisman.config_file.disable_anims) then
        for i, _ in ipairs(cards) do
            local card = cards[i]
            if card then
                G.E_MANAGER:add_event(
                    Event(
                        {
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                if card.flip then
                                    card:flip()
                                end
                                return true
                            end
                        }
                    )
                )
            end
        end
    end
end

function fix_decimal_hand_levels()
    if not (G and G.GAME and G.GAME.hands) then
        return
    end
    for name, hand in pairs(G.GAME.hands) do
        local lvl = G.GAME.hands[name].level
        if math.floor(lvl) ~= lvl then
            G.GAME.hands[name].level = math.floor(lvl)
        end
    end
end

function area_by_key(key)
    local t = key:sub(1, 1)

    if t == "j" then
        return G.jokers
    elseif t == "c" then
        return G.consumeables
    elseif t == "m" then
        return G.hand
    end
    return nil
end

function create_letters(str)
    str = str:gsub(" ", "")
    for i = 1, #str do
        local char = str:sub(i, i)

        local card = create_card("Default", G.hand, nil, nil, nil, nil, nil, nil)
        card:set_letters(char)
        card:add_to_deck()
        G.hand:emplace(card)
        card:set_ability("c_base")
    end
end

function add_random_tag(seed)
    local tag_pool = get_current_pool('Tag')
    local selected_tag = pseudorandom_element(tag_pool, pseudoseed(seed))
    local it = 1
    while selected_tag == 'UNAVAILABLE' do
        it = it + 1
        selected_tag = pseudorandom_element(tag_pool, pseudoseed(seed .. it))
    end
    add_tag(Tag(selected_tag))
end

function Card:is_kitty()
    return Cryptid.safe_get(self.config.center, "pools", "Kitties") or self.count_as_kitty
end

function kitty_count(base)
    local c = base or 0
    for i, joker in ipairs((G.jokers and G.jokers.cards) or {}) do
        if joker:is_kitty() then
            c = c + 1
        end
    end
    return c
end

function vallkarri.count_kitty_tags()
    local c = 0
    for i, tag in ipairs(G.GAME.tags or {}) do
        if tag.key == "tag_valk_kitty" then
            c = c + 1
        end
    end
    return c
end

function lerpcolour(c1, c2, percent)
    local new = {}

    if not lerp then
        return { (c1[1] + c2[1]) / 2, (c1[2] + c2[2]) / 2, (c1[3] + c2[3]) / 2, 1 }
    end

    new[1] = lerp(c1[1], c2[1], math.log10(percent / 10)) --strange, i know.
    new[2] = lerp(c1[2], c2[2], math.log10(percent / 10))
    new[3] = lerp(c1[3], c2[3], math.log10(percent / 10))
    return { new[1], new[2], new[3], 1 }
end

function vallkarri.create_all_jokers_from(mod)
    for i, joker in ipairs(G.P_CENTER_POOLS.Joker) do
        if joker.original_mod and joker.original_mod.id == mod then
            local jkr = SMODS.create_card({ key = joker.key })
            jkr:add_to_deck()
            G.jokers:emplace(jkr)
        end
    end
end

function vallkarri.reset_hand_text()
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
        { mult = 0, chips = 0, handname = '', level = '' })
end

function vallkarri.search(search_table, find)
    for name, value in pairs(search_table) do
        if string.find(name, find) then
            print(name .. ": " .. tostring(value))
        end
    end
end

function vallkarri.list_banned_keys()
    for key, is_banned in pairs(G.GAME.banned_keys) do
        if is_banned then
            print(key .. " is banned. Set: " .. G.P_CENTERS[key].set)
        end
    end
end

function vallkarri.get_ordered_highlighted(cardarea)
    local ordered = {}

    for _, card in pairs(cardarea.cards) do
        for _, highlighted_card in pairs(cardarea.highlighted) do
            if highlighted_card == card then
                ordered[#ordered + 1] = card
            end
        end
    end

    return ordered
end

function vallkarri.get_adjacent_cards(card)
    local index = get_index(card.area.cards, card)

    return { card.area.cards[index - 1], card.area.cards[index + 1] }
end

function vallkarri.for_each(tab, func)
    local cards = tab.cards and tab.cards or tab

    for _, card in pairs(cards) do
        func(card)
    end
end

function vallkarri.hypercap(n, cap)
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

function vallkarri.index(card)
    local area = card.area

    if not area then
        return false
    end
    for i, c in ipairs(area.cards) do
        if c == card then
            return i
        end
    end
    return false
end

function vallkarri.adjacent_aesthetijoker(card)
    local left = card.area.cards[vallkarri.index(card) - 1]
    local right = card.area.cards[vallkarri.index(card) + 1]
    local ret_value = nil
    if left and Cryptid.safe_get(left.config.center, "pools", "aesthetijoker") then
        ret_value = left
    end

    if right and Cryptid.safe_get(right.config.center, "pools", "aesthetijoker") then
        ret_value = right
    end

    return ret_value
end

function Card:apply_aesthetijoker_edition()
    local aesthetijoker = vallkarri.adjacent_aesthetijoker(self)
    if aesthetijoker then
        local ed = aesthetijoker.ability.extra.edition
        local reset = ed == (self.edition and self.edition.key)
        self:set_edition(ed, reset, reset)
    else
        self:set_edition(nil, self.edition == nil, self.edition == nil)
    end
end

function vallkarri.random_key_from_pool(pool)
    local _pool, _pool_key = get_current_pool(pool, nil, nil, "valk_rand")
    local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
    local it = 1
    while center == 'UNAVAILABLE' do
        it = it + 1
        center = pseudorandom_element(_pool, pseudoseed(_pool_key .. '_resample' .. it))
    end
    return center
end

function vallkarri.load(save_name)
    if G.GAME and G.GAME.vallkarri_saves and G.GAME.vallkarri_saves[save_name] then
        G.E_MANAGER:add_event(
            Event({
                trigger = "after",
                delay = G.SETTINGS.GAMESPEED,
                func = function()
                    G:delete_run()
                    G:start_run({
                        savetext = STR_UNPACK(G.GAME.vallkarri_saves[save_name]),
                    })
                end,
            }),
            "other"
        )
    end
end

function vallkarri.save(save_name)
    G.GAME.vallkarri_saves = G.GAME.vallkarri_saves or {}
    G.GAME.vallkarri_saves[save_name] = STR_PACK(G.culled_table)
end

function vallkarri.best_hand_chips()
    return G.GAME.round_scores["hand"].amt
end

function vallkarri.initialize_splashtext()
    --credit to JTEM from Hot Potato for Making This code Most.ly
    --  but it is also dyantext shenanigans so  its not that complicated
    G.valk_splash = DynaText {
        colours = { G.C.VALK_PRESTIGIOUS_LIGHTER },
        shadow = true,
        spacing = 1.5,
        bump = true,
        scale = 0.55,
        -- string = {ref_table = vallkarri, ref_value = "main_menu_text"},
        string = vallkarri.main_menu_text or ""
    }
    G.valk_splash.VT.r = -0.07
    G.valk_splash.T.r = -0.07
    G.valk_splash:update_text(true)
    G.valk_splash:set_alignment({
        major = G.title_top,
        type = 'cm',
        bond = 'Strong',
        offset = { x = 2.3, y = 2.4 }
    })
end

function vallkarri.simple_draw(card, to)
    draw_card(card.area, to, nil, nil, nil, card, nil, nil, false)
end

function vallkarri.mods_installed()
    local mods = 0
    for _, mod in pairs(SMODS.Mods) do
        mods = mods + (mod.can_load and 1 or 0)
    end
    return mods
end

function vallkarri.poll_face(seed)
    local faces = { "Jack", "Queen", "King" }
    return pseudorandom_element(faces, seed)
end

function vallkarri.poll_number(seed)
    return pseudorandom(seed, 2, 10)
end

function Card:is_in_collection()
    for _, area in pairs(G.your_collection) do
        if self.area == area then
            return true
        end
    end
    return false
end

function vallkarri.get_cards(area)
    local cards = {}
    for _, card in pairs(area.cards) do
        table.insert(cards, card)
    end
    return cards
end

function vallkarri.hashing_completed()
    G.valk_hash_complete_text = DynaText {
        colours = { HEX("00FF00") },
        shadow = true,
        spacing = 1.5,
        bump = true,
        scale = 0.4,
        -- string = {ref_table = vallkarri, ref_value = "main_menu_text"},
        string = "Hashing complete!"
    }
    G.valk_hash_complete_text:update_text(true)
    G.valk_hash_complete_text:set_alignment({
        major = G.ROOM_ATTACH,
        type = 'cm',
        bond = 'Strong',
        offset = { x = 9, y = -5 }
    })
    ease_value(G.valk_hash_complete_text.colours[1], 4, -1)

    G.E_MANAGER:add_event(Event({
        func = function()
            if G.valk_hash_complete_text.colours[1][4] <= 0 then
                G.valk_hash_complete_text:remove()
                G.valk_hash_complete_text = nil
                return true
            end
        end
    }), "other")
end

vallkarri.sum_blacklist = {
    h_chips = true,
    repetitions = true,
    h_x_chips = true,
    perma_mult = true,
    t_mult = true,
    h_dollars = true,
    perma_p_dollars = true,
    extra_value = true,
    perma_bonus = true,
    extra_slots_used = true,
    perma_x_mult = true,
    h_size = true,
    bonus = true,
    x_mult = true,
    order = true,
    perma_h_x_mult = true,
    perma_repetitions = true,
    hands_played_at_create = true,
    perma_h_chips = true,
    x_chips = true,
    perma_h_dollars = true,
    d_size = true,
    perma_x_chips = true,
    perma_h_x_chips = true,
    p_dollars = true,
    perma_h_mult = true,
    h_x_mult = true,
    t_chips = true,
    h_mult = true,
    immutable = true,
    card_limit = true,
}

vallkarri.min_value = 0

function vallkarri.recursive_sum(table)
    local sum = 0
    local count = 0
    for key, v in pairs(table) do
        if (type(v) == "number" or (getmetatable(v) == OmegaMeta)) and (not vallkarri.sum_blacklist[key]) and to_big(v) > to_big(vallkarri.min_value) then --pray to fucking god that it's not a card object or some bullshit
            sum = sum + v
            count = count + 1
        elseif (type(v) == "table") and (not vallkarri.sum_blacklist[key]) then
            local nsum, ncount = vallkarri.recursive_sum(v)
            sum = sum + nsum
            count = count + ncount
        end
    end
    return sum, count
end

function vallkarri.recursive_set(table, value)
    for key, v in pairs(table) do
        if (type(v) == "number" or (getmetatable(v) == OmegaMeta)) and (not vallkarri.sum_blacklist[key]) and to_big(v) > to_big(vallkarri.min_value) then --pray to fucking god that it's not a card object or some bullshit
            table[key] = value
        elseif (type(v) == "table") and (not vallkarri.sum_blacklist[key]) then
            vallkarri.recursive_set(v, value)
        end
    end
end

function vallkarri.set_all(table, value)
    for k,v in pairs(table) do
        table[k] = value
    end
end

-- gives a cards eternal state
function Card:is_eternal()
    return not not self.ability.eternal
end

-- sets a cards eternal state. bypasses if it's allowed or not
function Card:set_eternal_bypass(_eternal)
    self.ability.eternal = _eternal
end

function vallkarri.merge_lists(a, b)
    local newlist = {}

    for _, entry in ipairs(a) do
        table.insert(newlist, entry)
    end

    for _, entry in ipairs(b) do
        table.insert(newlist, entry)
    end

    return newlist
end

-- stolen from ruby entropy
-- function vallkarri.l_chipsmult(hand, card, l_chips, l_mult)
--     update_hand_text({ delay = 0 },
--         { handname = localize(hand, "poker_hands"), level = G.GAME.hands[hand].level, mult = Entropy.ascend_hand(
--         G.GAME.hands[hand].mult, hand), chips = Entropy.ascend_hand(G.GAME.hands[hand].chips, hand) })
--     delay(1)
--     G.E_MANAGER:add_event(Event({
--         trigger = 'after',
--         delay = 0.2,
--         func = function()
--             play_sound('tarot1')
--             if card and card.juice_up then card:juice_up(0.8, 0.5) end
--             G.TAROT_INTERRUPT_PULSE = true
--             return true
--         end
--     }))
--     update_hand_text({ delay = 0 },
--         { handname = localize("k_level_chips"), chips = G.GAME.hands[hand].l_chips, mult = G.GAME.hands[hand].l_mult })
--     delay(2)
--     G.GAME.hands[hand].l_chips = G.GAME.hands[hand].l_chips + l_chips
--     update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 },
--         { chips = G.GAME.hands[hand].l_chips, StatusText = true })
--     delay(0.7)
--     G.E_MANAGER:add_event(Event({
--         trigger = 'after',
--         delay = 0.2,
--         func = function()
--             play_sound('tarot1')
--             if card and card.juice_up then card:juice_up(0.8, 0.5) end
--             G.TAROT_INTERRUPT_PULSE = true
--             return true
--         end
--     }))
--     update_hand_text({ delay = 0 },
--         { handname = localize("k_level_mult"), chips = G.GAME.hands[hand].l_chips, mult = G.GAME.hands[hand].l_mult })
--     delay(2)
--     G.GAME.hands[hand].l_mult = G.GAME.hands[hand].l_mult + l_mult
--     update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 },
--         { mult = G.GAME.hands[hand].l_mult, StatusText = true })
--     delay(0.7)
--     G.E_MANAGER:add_event(Event({
--         trigger = 'after',
--         delay = 0.2,
--         func = function()
--             play_sound('tarot1')
--             if card and card.juice_up then card:juice_up(0.8, 0.5) end
--             G.TAROT_INTERRUPT_PULSE = true
--             return true
--         end
--     }))
--     delay(1.3)
--     vallkarri.reset_to_none()
-- end

function vallkarri.l_chipsmult_allhands(card, l_chips, l_mult)
    update_hand_text({ delay = 0 }, { handname = localize("k_all_hands"), mult = "...", chips = "..." })
    delay(1)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    update_hand_text({ delay = 0 }, { handname = localize("k_all_hands"), chips = l_chips })
    delay(2)
    for key, handtype in pairs(G.GAME.hands) do
        G.GAME.hands[key].l_chips = G.GAME.hands[key].l_chips + l_chips
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { chips = l_chips, StatusText = true })
    delay(0.7)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    update_hand_text({ delay = 0 }, { handname = localize("k_all_hands"), mult = l_mult })
    delay(2)
    for key, handtype in pairs(G.GAME.hands) do
        G.GAME.hands[key].l_mult = G.GAME.hands[key].l_mult + l_mult
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { mult = l_mult, StatusText = true })
    delay(0.7)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    delay(1.3)
    vallkarri.reset_to_none()
end

function vallkarri.xl_chipsmult_allhands(card, l_chips, l_mult)
    update_hand_text({ delay = 0 }, { handname = localize("k_all_hands"), mult = "...", chips = "..." })
    delay(1)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    -- update_hand_text({ delay = 0 }, { handname = localize("k_all_hands"), chips = l_chips })
    delay(2)
    for key, handtype in pairs(G.GAME.hands) do
        G.GAME.hands[key].l_chips = G.GAME.hands[key].l_chips * l_chips
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { chips = l_chips, StatusText = true, chips_pre = "X" })
    delay(0.7)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    -- update_hand_text({ delay = 0 }, { handname = localize("k_all_hands"), mult = l_mult })
    delay(2)
    for key, handtype in pairs(G.GAME.hands) do
        G.GAME.hands[key].l_mult = G.GAME.hands[key].l_mult * l_mult
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { mult = l_mult, StatusText = true, mult_pre = "X" })
    delay(0.7)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    delay(1.3)
    vallkarri.reset_to_none()
end

function Moveable:juice_until(eval_func, delay, amount, rotation)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay or 0.1,
        blocking = false,
        blockable = false,
        timer = 'REAL',
        func = (function()
            if eval_func(self) then
                if self.juice_up then self:juice_up(amount or 0.1, rotation or 0.1) end; self:juice_until(eval_func, delay, amount, rotation)
            end
            return true
        end)
    }))
end

function vallkarri.juice_everything_forever(delay, amount, rotation)
    for key,value in pairs(G.I) do
        for _,object in pairs(value) do
            if object.juice_until then
                object:juice_until(function() return true end, delay, amount, rotation)
            end
        end
    end
end

function vallkarri.reset_to_none()
    update_hand_text({ delay = 0 }, {
        mult = 0,
        chips = 0,
        level = "",
        handname = "",
    })
end
