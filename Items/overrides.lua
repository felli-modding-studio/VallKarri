local mainmenu = Game.main_menu
Game.main_menu = function(change_context) --code heavily adapted from cryptid
    local ret = mainmenu(change_context)

    math.randomseed(os.time())
    vallkarri.main_menu_text = vallkarri.choose_main_menu_text()

    if (G.P_CENTERS.j_valk_lily) then
        G.E_MANAGER:add_event(Event({
            func = function()
                local newcard = Card(
                    G.title_top.T.x,
                    G.title_top.T.y,
                    G.CARD_W,
                    G.CARD_H,
                    G.P_CARDS.empty,
                    G.P_CENTERS.j_valk_lily, --replace this with the p_center of your card, you can keep everything else the same
                    { bypass_discovery_center = true }
                )
                newcard.click = function(self)
                    G.FUNCS["openModUI_" .. self.config.center.mod.id]()
                end
                G.title_top:emplace(newcard)
                newcard:start_materialize({ G.C.BLUE }, false, G.SETTINGS.GAMESPEED * 0.25)
                newcard.T.w = newcard.T.w * 1.1 * 1.2
                newcard.T.h = newcard.T.h * 1.1 * 1.2
                newcard.no_ui = true
                newcard:set_sprites(newcard.config.center)

                if #G.title_top.cards == 2 then
                    for _, card in pairs(G.title_top.cards) do
                        if card.base.id then
                            card:start_dissolve({ G.C.BLUE }, false, G.SETTINGS.GAMESPEED * 0.25)
                        end
                    end
                end

                vallkarri.initialize_splashtext()
                return true
            end,
            trigger = "after",
            delay = 0.25,
        }))
    end


    return ret
end

local hookref_atd = Card.add_to_deck

-- load other files here

-- stop loading other files because thats how code works

local edcopy = ease_dollars

function ease_dollars(mod, instant)
    if G.GAME.price_mod then
        edcopy(mod + G.GAME.price_mod, true)
        return
    end

    edcopy(mod, instant)
end

local count = 0
local concurrency = false
local fakeupd = Game.update
function Game:update(dt)
    fakeupd(self, dt)

    if (G.GAME.mult_disabled and G.STATE and G.STATE == 1) then
        -- refresh during blinds
        G.HUD:get_UIE_by_ID("hand_mult_area").UIT = 0
    end

    if G.PROFILES and G.SETTINGS.profile and G.PROFILES[G.SETTINGS.profile] then
        G.PROFILES[G.SETTINGS.profile].cry_gameset = "madness"
        G.PROFILES[G.SETTINGS.profile].cry_intro_complete = true
    end

    local popped = love.thread.getChannel("hash"):pop()
    if popped then
        vallkarri.HASH = popped
        vallkarri.debug_info = vallkarri.debug_info or {}
        vallkarri.debug_info.MOD_HASH = vallkarri.HASH
        vallkarri.hashing_completed()
    end

    if (count > 30) then
        count = 0
        vallkarri.update_last_message()
    else
        count = count + dt
    end

    if (os.time() % 60) == 5 and concurrency then
        vallkarri.count_player()
        concurrency = false
    end

    if (os.time() % 60) == 0 then
        concurrency = true
    end
    if G.GAME.round_resets.eante_ante_diff and G.GAME.round_resets.eante_ante_diff ~= 0 then
        G.GAME.round_resets.eante_disp = "(" ..
            number_format(G.GAME.round_resets.eante_ante_diff + G.GAME.round_resets.ante) .. ")"
    else
        G.GAME.round_resets.eante_disp = ""
    end

    fix_decimal_hand_levels()
end

local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)
    G.GAME.run_ante_modifiers = G.GAME.run_ante_modifiers or {}

    if args.savetext then
        return
    end

    G.GAME.run_ante_modifiers = {}

    if not G.GAME.vallkarri then
        G.GAME.vallkarri = {}
        G.GAME.vallkarri.spawn_multipliers = {}
        G.GAME.vallkarri.banned_use_keys = {}
        for key, _ in pairs(G.P_CENTERS) do
            G.GAME.vallkarri.spawn_multipliers[key] = 1
            G.GAME.vallkarri.banned_use_keys[key] = false
        end
    end

    if not G.GAME.ante_config and config_reset then
        config_reset()
    end


    for name, center in pairs(G.P_CENTERS) do
        if center.old_weight then
            G.P_CENTERS[name].weight = center.old_weight
        end
    end

    G.jokers.config.highlighted_limit = 1e10 -- bleehhhhhh
end

glcui = nil


local gcui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local tab = gcui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    -- glcui = tab
    local center = G.P_CENTERS[_c.key]

    if not center then
        return tab
    end

    if not center.displaying_lore then
        return tab
    end

    local ex_lang = G.LANGUAGES["en-us"]
    tab.main = {}

    for i, line in ipairs(center.lore) do
        -- print(line)
        tab.main[#tab.main + 1] = { {
            n = 1,
            config = {
                scale = 0.25,
                outline_colour = G.C.UI.OUTLINE_LIGHT,
                text_drawable = love.graphics.newText(ex_lang.font.FONT, { G.C.UI.TEXT_INACTIVE, line }),
                colour = G.C.UI.TEXT_INACTIVE,
                text = line,
                lang = ex_lang
            }
        } }
    end

    return tab
end

G.FUNCS.can_learn_more = function(e)
    if e.config.ref_table:can_learn_more() then
        e.config.colour = HEX("e5bf3a")
        e.config.button = 'learn_more'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.learn_more = function(button)
    local card = button.config.ref_table
    card.config.center.displaying_lore = not card.config.center.displaying_lore

    -- print(card.config.center.displaying_lore)
end

function Card:can_learn_more(context)
    return true
end

local fakeusesell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ref = fakeusesell(card)
    -- print(ref)
    -- print(ref.nodes[1])

    if card.config.center.lore then
        ref.nodes[1].nodes[#ref.nodes[1].nodes + 1] = {
            n = G.UIT.C,
            config = { align = "tm" },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { ref_table = card, align = "tl", padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = false, button = 'learn_more', func = 'can_learn_more' },
                    nodes = {
                        { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                        {
                            n = G.UIT.C,
                            config = { align = "tm" },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm", maxw = 1.25 },
                                    nodes = {
                                        { n = G.UIT.T, config = { text = "Toggle lore", colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true } }
                                    }
                                },
                            }
                        }
                    }
                },
            }
        }
    end

    return ref
end

-- if talisman exists this function still needs to exist to avoid crashing
local eval_hyperop = function(...) end

-- eval tetration
if not Talisman then
	eval_hyperop = function(effect, scored_card, key, amount, from_edition)
		if (key == "ee_chips" or key == "eechips" or key == "EEchip_mod") and amount ~= 1 then
			if effect.card then
				juice_card(effect.card)
			end
			local chips = SMODS.Scoring_Parameters["chips"]
			chips:modify(vallkarri.tetrate(chips.current, amount) - chips.current)
			if not effect.remove_default_message then
				if from_edition then
					card_eval_status_text(
						scored_card,
						"jokers",
						nil,
						percent,
						nil,
						{
							message = localize{
								type = "variable",
								key = "a_valk_eechips",
								vars = {
									number_format(amount),
								},
							},
							colour = G.C.DARK_EDITION,
                            edition = true
						}
					)
				elseif key ~= "EEchip_mod" then
					if effect.eechip_message then
                        card_eval_status_text(
                            effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
                            "extra",
                            nil,
                            percent,
                            nil,
                            effect.eechip_message
                        )
                    else
                        card_eval_status_text(
                            effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
                            "ee_chips",
                            amount,
                            percent
                        )
                    end
				end
			end
			return true
		end
		if (key == "ee_mult" or key == "eemult" or key == "EEmult_mod") and amount ~= 1 then
			if effect.card then
				juice_card(effect.card)
			end
			local mult = SMODS.Scoring_Parameters["mult"]
			mult:modify(vallkarri.tetrate(mult.current, amount) - mult.current)
			if not effect.remove_default_message then
				if from_edition then
					card_eval_status_text(
						scored_card,
						"jokers",
						nil,
						percent,
						nil,
						{
                            message = localize{
								type = "variable",
								key = "a_valk_eemult",
								vars = {
									number_format(amount),
								},
							},
                            colour = G.C.DARK_EDITION,
                            edition = true
                        }
					)
				elseif key ~= "EEmult_mod" then
                    if effect.eemult_message then
                        card_eval_status_text(
                            effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
                            "extra",
                            nil,
                            percent,
                            nil,
                            effect.eemult_message
                        )
                    else
                        card_eval_status_text(
                            effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
                            "ee_mult",
                            amount,
                            percent
                        )
                    end
				end
			end
			return true
		end
	end
	for _, v in ipairs{
		"ee_mult", "eemult", "EEmult_mod",
		"ee_chips", "eechips", "EEchip_mod",
	} do
		SMODS.scoring_parameter_keys[#SMODS.scoring_parameter_keys+1] = v
	end
end

for _, v in ipairs{
    "multe", "chipse",
    "eqzulu", "zulu", "xzulu",
} do
    SMODS.scoring_parameter_keys[#SMODS.scoring_parameter_keys+1] = v
end
-- MUST HAVE THIS, WILL NOT WORK WITHOUT ADDING NEW CALC KEYS

local calceff = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if scored_card and scored_card.ability and scored_card.ability.valk_marked_for_death then
        if G.GAME.current_round.hands_left ~= 1 then
            ease_hands_played(-(G.GAME.current_round.hands_left - 1))
        end
        ease_discard(-4)
        return false
    end

    local ret = calceff(effect, scored_card, key, amount, from_edition) or eval_hyperop(effect, scored_card, key, amount, from_edition)
    if ret then return ret end

    if G.GAME.zulu and key ~= "zulu" then
        if type(amount) == "number" or (type(amount) == "table" and amount.tetrate) then
            amount = (1 + amount) ^ G.GAME.zulu
        end

        for n, obj in pairs(effect) do
            if n ~= "zulu" and type(obj) == "number" or (type(obj) == "table" and obj.tetrate) then
                effect[n] = (1 + effect[n]) ^ G.GAME.zulu
            end
        end
    end

    if key == "multe" and amount ~= 1 then
        if effect.card then juice_card(effect.card) end
        local mult = SMODS.Scoring_Parameters["mult"]
		mult:modify((amount ^ mult.current) - mult.current)
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
                { message = amount .. "^" .. localize("k_mult"), colour = G.C.EDITION, edition = true })
        end
        return true
    end

    if key == "chipse" and amount ~= 1 then
        if effect.card then juice_card(effect.card) end
        local chips = SMODS.Scoring_Parameters["chips"]
		chips:modify((amount ^ chips.current) - chips.current)
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
                { message = amount .. "^" .. localize("k_chips"), colour = G.C.EDITION, edition = true })
        end
        return true
    end

    if key == "eqzulu" then
        if effect.card then juice_card(effect.card) end
        G.GAME.zulu = to_big(amount)
        update_hand_text({ delay = 0 }, { chips = hand_chips .. "??", mult = mult .. "??" })
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
                {
                    message = "=" .. amount .. " Zulu",
                    colour = G.C.GREEN,
                    sound = 'voice' .. math.random(1, 11),
                    pitch = 0.2,
                    volume = 10,
                    trigger =
                    "immediate",
                })
        end
        return true
    end

    if key == "zulu" then
        if effect.card then juice_card(effect.card) end
        G.GAME.zulu = to_big(G.GAME.zulu and (G.GAME.zulu + amount) or amount)
        update_hand_text({ delay = 0 }, { chips = hand_chips .. "?", mult = mult .. "?" })
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
                {
                    message = "+" .. amount .. " Zulu",
                    colour = G.C.GREEN,
                    sound = 'voice' .. math.random(1, 11),
                    pitch = 0.2,
                    volume = 10,
                    trigger =
                    "immediate",
                })
        end
        return true
    end

    if key == "xzulu" then
        if effect.card then juice_card(effect.card) end
        G.GAME.zulu = G.GAME.zulu and (G.GAME.zulu * amount) or to_big(0)
        update_hand_text({ delay = 0 }, { chips = hand_chips .. "?", mult = mult .. "?" })
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
                {
                    message = "X" .. amount .. " Zulu",
                    colour = G.C.GREEN,
                    sound = 'voice' .. math.random(1, 11),
                    pitch = 0.1,
                    volume = 20,
                    trigger =
                    "immediate",
                })
        end
        return true
    end
end

if #SMODS.find_mod("entr") > 0 then
    function Entropy.CanEeSpawn()
        return false
    end
end


local fakecreate = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if G.GAME.legendary_replace and pseudorandom("valk_legendary_replace", 1, 100) <= G.GAME.legendary_replace and not forced_key and _type == "Joker" then
        _rarity = 4
        legendary = true
    end

    if G.GAME.exquisite_replace and pseudorandom("valk_exquisite_replace") * 100 < G.GAME.exquisite_replace and not forced_key and _type == "Joker" then
        _rarity = "valk_exquisite"
    end

    if G.GAME.prestigious_replace and pseudorandom("valk_prestigious_replace") * 100 < G.GAME.prestigious_replace and not forced_key and _type == "Joker" then
        _rarity = "valk_prestigious"
    end

    if G.GAME.unsurpassed_replace and pseudorandom("valk_unsurpassed_replace") * 100 < G.GAME.unsurpassed_replace and not forced_key and _type == "Joker" then
        _rarity = "valk_unsurpassed"
    end

    if G.GAME.cursed_replace and pseudorandom("valk_cursed_replace") * 100 < G.GAME.cursed_replace and not forced_key and _type == "Joker" then
        _rarity = "cry_cursed"
    end

    if G.GAME.supercursed_replace and pseudorandom("valk_supercursed_replace") * 100 < G.GAME.supercursed_replace and not forced_key and _type == "Joker" then
        _rarity = "valk_supercursed"
    end

    if _type == "Tarot" and G.GAME.tarot_planet_replacement and pseudorandom("valk_tarot_replace", 1, 100) <= G.GAME.tarot_planet_replacement then
        _type = "Planet"
    end

    if _type == "Spectral" and G.GAME.spectral_planet_replacement and pseudorandom("valk_spectral_replace", 1, 100) <= G.GAME.spectral_planet_replacement then
        _type = "Planet"
    end

    if not forced_key and G.GAME.spectral_replace and pseudorandom("valk_spectral_replace", 1, 100) <= G.GAME.spectral_replace then
        _type = "Spectral"
    end

    if not forced_key and G.GAME.tarot_replace and pseudorandom("valk_tarot_replace", 1, 100) <= G.GAME.tarot_replace then
        _type = "Tarot"
    end

    if not forced_key and G.GAME.planet_replace and pseudorandom("valk_planet_replace", 1, 100) <= G.GAME.planet_replace then
        _type = "Planet"
    end



    local out = fakecreate(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)


    if G.GAME.vallkarri and G.GAME.vallkarri.spawn_multipliers and G.GAME.vallkarri.spawn_multipliers[out.config.center.key] then
        Cryptid.manipulate(out, { value = G.GAME.vallkarri.spawn_multipliers[out.config.center.key] })
    end

    if (G.GAME.hidden_override and out.ability.set == "Spectral" and not out.config.center.hidden and pseudorandom("valk_hidden_override", 1, 100) <= G.GAME.hidden_override) then
        local choices = {}

        for i, center in ipairs(G.P_CENTER_POOLS.Spectral) do
            if center.hidden and center.key then
                choices[#choices + 1] = center.key
            end
        end
        out:set_ability(choices[pseudorandom("valk_hidden_override2", 1, #choices)])
    end

    -- print(out.config.center.key .. "from " .. key_append)
    return out
end

local addtaghook = add_tag

function add_tag(_tag)
    if not (G.GAME.ban_tags) then
        addtaghook(_tag)
    end
end

function Card:is_immortal()
    return (self and self.config and self.config.center and self.config.center.immortal)
end

local card_remove = Card.remove
local card_remove_deck = Card.remove_from_deck
function Card:remove(...)
    if self:is_immortal() and self.area then
        quick_card_speak(self, self.config.center.immortal_speak)
        self:start_materialize({ G.C.BLACK }, false, G.SETTINGS.GAMESPEED)
        self:deselect()
    else
        card_remove(self, ...)
    end
end

function Card:remove_from_deck(...)
    if not self:is_immortal() then
        card_remove_deck(self, ...)
    end
end

-- local original_cost = Card.set_cost
-- function Card:set_cost()
--     original_cost(self)

--     local new = to_number(math.min(math.max(self.cost * math.ceil(G.GAME.dollars^0.25) * 0.5, self.cost), 2^1000))
--     local diff = new - self.cost
--     print(self.config.center.key .. " created, diff: " .. diff)
--     self.cost = new
-- end

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

    vallkarri.refresh_ante_diff()

    return calc_blind_amount(ante)
end

function vallkarri.refresh_ante_diff()
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

function vallkarri.add_effective_ante_mod(amount, operator)
    G.GAME.run_ante_modifiers[#G.GAME.run_ante_modifiers + 1] = { v = amount, o = operator }
    vallkarri.refresh_ante_diff()
end

local smodsinject = SMODS.injectItems

function SMODS.injectItems(...)
    smodsinject(...)

    for key, card in pairs(G.P_CENTERS) do

        if card.valk_artist then
            vallkarri.credited_artists[card.valk_artist] = vallkarri.credited_artists[card.valk_artist] or {}
            table.insert(vallkarri.credited_artists[card.valk_artist], card.key)
        end
    end

    for name, center in pairs(G.P_CENTERS) do
        local original_locvar = G.P_CENTERS[name].loc_vars
        G.P_CENTERS[name].loc_vars = original_locvar and function(self, info_queue, card)
            local original_results = original_locvar(self, info_queue, card)
            if card and card.edition and card.edition.key == "e_valk_censored" and original_results and original_results.vars and #original_results.vars > 0 then
                for i = 1, #original_results.vars do
                    -- entropy easter egg
                    local options = { "[REDACTED]", "[DATA EXPUNGED]" }
                    local newspeak = (SMODS.Mods.entr or {}).can_load and Entropy.DeckOrSleeve("doc") and
                        options[math.random(1, #options)] or "???"
                    original_results.vars[i] = newspeak
                end
            end


            return original_results
        end
    end
end

local old_draw = Game.draw
function Game:draw()
    old_draw(self)



    local found = next(SMODS.find_card("j_valk_borderline_joker"))
    if found then
        local scott_blue = HEX("3b56ff")
        local width = SMODS.find_card("j_valk_borderline_joker")[1].ability.extra.border_width

        love.graphics.setColor(scott_blue)
        love.graphics.rectangle("fill", 0, 0, width, love.graphics.getHeight())
        love.graphics.rectangle("fill", love.graphics.getWidth() - width, 0, width, love.graphics.getHeight())
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() - width, width)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight() - width, love.graphics.getWidth(), width)
    end
end

local olddrag = Card.stop_drag
function Card:stop_drag()
    olddrag(self)

    -- SMODS.calculate_context({valk_rearrange = true, card = self})
    if not G.jokers then
        return
    end

    local has_aesthetijoker = false

    for _, joker in pairs(G.jokers.cards) do
        has_aesthetijoker = has_aesthetijoker or Cryptid.safe_get(joker.config.center, "pools", "aesthetijoker")
    end

    if not has_aesthetijoker then
        return
    end


    for _, joker in pairs(G.jokers.cards) do
        joker:apply_aesthetijoker_edition()
    end
end

local olddebuff = Card.set_debuff
function Card:set_debuff(debuff)
    if debuff and next(SMODS.find_card("j_valk_frutiger")) and self.edition and self.edition.key == "e_foil" then
        olddebuff(self, false)
        quick_card_speak(self, localize("k_nope_ex"))
        return
    end
    olddebuff(self, debuff)
end

local cardcanuse = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check)
    local original_value = cardcanuse(self, any_state, skip_check)

    if G.GAME.vallkarri.banned_use_keys[self.config.center_key] then
        return false
    end

    return original_value
end

local cardcanbuy = G.FUNCS.can_buy
G.FUNCS.can_buy = function(e)
    local key = e.config.ref_table.config.center_key
    if G.GAME.vallkarri.banned_use_keys[key] then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        if e.config.ref_parent and e.config.ref_parent.children.buy_and_use then
            if e.config.ref_parent.children.buy_and_use.states.visible then
                e.UIBox.alignment.offset.y = -0.6
            else
                e.UIBox.alignment.offset.y = 0
            end
        end
    else
        cardcanbuy(e)
    end
end

local can_sellref = Card.can_sell_card
function Card:can_sell_card(context)
    return can_sellref(self, context) and not self:is_eternal()
end