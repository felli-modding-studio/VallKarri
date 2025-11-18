SMODS.Rarity {
    key = 'renowned',
    loc_txt = {
        name = 'Renowned'
    },
    badge_colour = G.C.VALK_RENOWNED,
    pools = { ["Joker"] = true },
    default_weight = 0.01,
    --approx 3x more common than a cryptid epic joker
}

SMODS.Joker {
    key = "raxd",
    loc_txt = {
        name = "raxdflipnote",
        text = {
            "When {C:attention}Boss Blind{} is defeated, create a {C:dark_edition,T:e_negative}Negative{} {C:rare}Rare Joker{}",
            "{C:green}#1# in #2#{} chance to spawn an {C:purple}Eternal{} {C:common}Common Joker{} instead",
            "{C:inactive}(Must have room){}",
            quote("raxd"),
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { state = 1, ctr = 0, num = 1, den = 10 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "raxd")
        return { vars = { num, den } }
    end,
    rarity = "valk_renowned",
    atlas = "main",
    pos = { x = 0, y = 6 },
    soul_pos = { x = 1, y = 6 },
    cost = 15,
    demicoloncompat = false,
    update = function(self, card, front)
        if card.ability and card.ability.extra.state and card.ability.extra.ctr and card.children and card.children.center and card.children.floating_sprite then
            card.ability.extra.ctr = (card.ability.extra.ctr + 1) % 5
            if (card.ability.extra.ctr == 0) then
                card.ability.extra.state = card.ability.extra.state + 1
                if card.ability.extra.state > 2 then
                    card.ability.extra.state = 1
                end
                card.children.floating_sprite:set_sprite_pos({ x = card.ability.extra.state, y = 6 })
            end
        end
    end,

    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval and G.GAME.blind.boss) then
            if SMODS.pseudorandom_probability(card, "valk_raxd", card.ability.extra.num, card.ability.extra.den) then
                if G.jokers.config.card_count < G.jokers.config.card_limit then
                    local common = SMODS.create_card({ set = "Joker", stickers = { "eternal" }, rarity = 0 })
                    common:add_to_deck()
                    G.jokers:emplace(common)
                end
            else
                local rare = SMODS.create_card({ set = "Joker", rarity = 1, edition = "e_negative" })
                rare:add_to_deck()
                G.jokers:emplace(rare)
            end
        end
    end
}

SMODS.Joker {
    key = "cascade",
    loc_txt = {
        name = "Cascading Chain",
        text = {
            "{X:dark_edition,C:white}X#1#{} Blind Size for every other {C:attention}Joker{} owned",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { mul = 0.95 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mul } }
    end,
    rarity = "valk_renowned",
    atlas = "main",
    pos = { x = 0, y = 10 },
    cost = 12,
    immutable = true,
    calculate = function(self, card, context)
        -- play_sound('timpani')
        -- G.GAME.blind.chips = G.GAME.blind.chips / amount
        -- G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        -- G.HUD_blind:recalculate()
        -- G.hand_text_area.blind_chips:juice_up()\

        if context.other_joker then
            --print("a")
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("timpani")
                    G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.mul
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    G.HUD_blind:recalculate()
                    G.hand_text_area.blind_chips:juice_up()
                    context.other_joker:juice_up()
                    return true
                end
            }))
            quick_card_speak(context.other_joker, "X" .. card.ability.extra.mul)
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "zulu",
    loc_txt = {
        name = "{C:valk_prestigious,s:2}Zulu",
        text = {
            "{X:mult,C:white}X1{} Mult",
            "{C:valk_prestigious,s:3,f:5}+π/10{C:valk_prestigious,s:3} Zulu",
            "{C:red,s:3.14159265}annihilates{}  a  few other cards",
        }
    },
    valk_artist = "Lily Felli",
    config = { extra = { zulu = math.pi / 10 } },
    rarity = "valk_renowned",
    atlas = "main",
    pos = { x = 4, y = 0 },
    cost = math.ceil(10 * math.pi),
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)

        return { vars = { card.ability.extra.zulu } }
    end,

    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then
            local to_kill = {}
            for i, jkr in ipairs(G.jokers.cards) do
                if jkr ~= card then table.insert(to_kill, jkr) end
            end
            SMODS.destroy_cards(to_kill)
            return { zulu = card.ability.extra.zulu, xmult = 1, }
        end

        if context.other_card and context.other_card.area == G.play then
            SMODS.destroy_cards({context.other_card})
        end
    end
}

SMODS.Joker {
    key = "wokegoe",
    rarity = "valk_renowned",
    loc_txt = {
        name = "{C:valk_gay}Wokegoe{}",
        text = {
            "Apply {C:dark_edition}Polychrome{} to a random Joker at end of round",
            "{C:dark_edition}Polychrome{} Jokers give an additional {X:mult,C:white}X#2#{} Mult when triggered",
            "{C:inactive}(Does not include self){}",
        }
    },
    valk_artist = "Poker The Poker",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.base,
                card.ability.extra.poly
            }
        }
    end,
    config = { extra = { base = 2, poly = 1.5 } },
    atlas = "main",
    pos = { x = 4, y = 10 },
    cost = 12,
    pools = { ["Meme"] = true },
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == "e_polychrome" then
            return {
                xmult = card.ability.extra.poly
            }
        end

        if context.end_of_round and context.main_eval then
            local valid = {}
            for i, jkr in ipairs(G.jokers.cards) do
                if (not jkr.edition) or (jkr.edition and jkr.edition.key ~= "e_polychrome") then
                    valid[#valid + 1] = jkr
                end
            end

            if #valid > 0 then
                pseudorandom_element(valid, "valk_woke_finn"):set_edition("e_polychrome")
            end
        end
    end,
}

SMODS.Joker {
    key = "imwithstupid",
    rarity = "valk_renowned",
    loc_txt = {
        name = "I'm with stupid",
        text = {
            "Retrigger the {C:attention}Joker{} to the left {C:attention}#1#{} time(s)",
            "Increase retrigger amount by {C:attention}#2#{} for",
            "every {C:attention}#3#{} {C:inactive}[#4#]{} played cards",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.retrig,
                card.ability.extra.inc,
                card.ability.extra.reset,
                card.ability.extra.req
            }
        }
    end,
    config = { extra = { retrig = 0, inc = 1, req = 20, reset = 20 } },
    atlas = "main",
    pos = { x = 11, y = 5 },
    cost = 12,
    immutable = true,
    pools = { ["Meme"] = true },
    calculate = function(self, card, context)
        if context.retrigger_joker_check and card.ability.extra.retrig > 0 then
            local my_index = 0
            for i, joker in ipairs(G.jokers.cards) do
                if joker == card then my_index = i end
            end

            if G.jokers.cards[my_index - 1] and context.other_card == G.jokers.cards[my_index - 1] then
                return {
                    repetitions = card.ability.extra.retrig
                }
            end
        end

        if context.joker_main then
            card.ability.extra.req = card.ability.extra.req - #context.scoring_hand
            if card.ability.extra.req < 0 then
                card.ability.extra.req = card.ability.extra.req + card.ability.extra.reset
                card.ability.extra.retrig = card.ability.extra.retrig + card.ability.extra.inc
            end
        end
    end,
}

SMODS.Joker {
    key = "heavyhands",
    rarity = "valk_renowned",
    loc_txt = {
        name = "Heavy Hands",
        text = {
            "Forcefully play your {C:attention}full{} hand",
            "{C:attention}+#1#{} Hand Size",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.handsize
            }
        }
    end,
    config = { extra = { handsize = 2 } },
    atlas = "atlas2",
    pos = { x = 2, y = 4 },
    cost = 12,
    immutable = true,
    calculate = function(self, card, context)
        if context.press_play then
            for i, c in ipairs(G.hand.cards) do
                if not c.highlighted then
                    draw_card(G.hand, G.play, nil, nil, nil, c, nil, nil, false)
                    c:highlight(true)
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.handsize)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.handsize)
    end,
}

SMODS.Joker {
    key = "ancientfingers",
    loc_txt = {
        name = "Ancient Fingers",
        text = {
            "All {V:1}#1#{} are forcefully played",
            "Draw {C:attention}two{} replacements for each card forcefully played",
        }
    },
    valk_artist = "mailingway",
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        local suit = G.GAME.current_round.ancient_card.suit
        local name = localize(suit, 'suits_plural')
        local colour = G.C.SUITS[suit]
        return { vars = { name, colours = { colour } } }
    end,
    rarity = "valk_renowned",
    atlas = "main",
    pos = { x = 12, y = 7 },
    -- soul_pos = {x=0, y=0},
    cost = 14,
    immutable = true,


    calculate = function(self, card, context)
        if context.press_play then
            G.E_MANAGER:add_event(
                Event(
                    {
                        trigger = "after",
                        delay = 0.1,
                        func = function()
                            local drawn = 0
                            local played = 0
                            for i, c in ipairs(G.hand.cards) do
                                if not c.highlighted and c:is_suit(G.GAME.current_round.ancient_card.suit) then
                                    draw_card(G.hand, G.play, nil, nil, nil, c, nil, nil, false)
                                    c:highlight(true)
                                    drawn = drawn + 1
                                end

                                if c.highlighted then
                                    played = played + 1
                                end
                            end

                            G.FUNCS.draw_from_deck_to_hand((drawn * 2) + played, true)
                            return true
                        end
                    }
                )
            )
        end
    end,

}

SMODS.Joker {
    key = "leopard_print",
    loc_txt = {
        name = "Leopard Print",
        text = {
            "Retrigger all {C:attention}Kitty{} Jokers once",
            "for each {C:attention}Kitty{} Joker owned",
        }
    },
    valk_artist = "mailingway",
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    rarity = "valk_renowned",
    atlas = "main",
    pos = { x = 12, y = 4 },
    cost = 8,
    blueprint_compat = true,
    pools = { ["Kitties"] = true },

    calculate = function(self, card, context)
        if context.retrigger_joker_check and Cryptid.safe_get(context.other_card.config.center, "pools", "Kitties") then
            local count = 0
            for _, joker in ipairs(G.jokers.cards) do
                if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                    count = count + 1
                end
            end

            return {
                repetitions = count
            }
        end
    end,
    in_pool = function(self, args)
        for i, joker in ipairs(G.jokers.cards) do
            if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                return true
            end
        end
        return false
    end,

}

SMODS.Joker {
    key = "callie",
    loc_txt = {
        name = "Callie",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult for each scoring {C:attention}Wild Card{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 0.05 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 11, y = 4 },
    cost = 6,
    rarity = "valk_renowned",
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(pcard, "m_wild") then
                    amount = amount + 1
                end
            end
            return { emult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
    in_pool = function()
        local wild = 0
        local total = 0
        for _,card in pairs(G.playing_cards) do
            if SMODS.has_enhancement(card, "m_wild") then 
                wild = wild + 1
            end
            total = total + 1
        end

        return (wild / total) > 0.1
        --need at least 10% of deck to be wild cards 
    end
}