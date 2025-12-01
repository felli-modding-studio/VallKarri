vallkarri.merged_tarot_rate = 0.01



SMODS.Consumable {
    key = "iron_maiden",
    set = "Tarot",
    loc_txt = {
        name = "Iron Maiden",
        text = {
            "Select up to {C:attention}#1#{} cards, convert",
            "all selected cards into the {C:attention}leftmost{} card, then",
            "apply {C:attention}steel{} to the leftmost card",
        }
    },
    config = { extra = { cards = 3 } },
    atlas = "main",
    pos = { x = 10, y = 0, },
    no_grc = true,
    valk_artist = "Scraptake",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        return { vars = { card.ability.extra.cards } }
    end,
    can_use = function(self, card)
        local highlighted = Cryptid.get_highlighted_cards({ G.hand }, card, 1, card.ability.extra.cards)
        return #highlighted > 0 and #highlighted <= card.ability.extra.cards
    end,

    use = function(self, card, area, copier)
        local highlighted = Cryptid.get_highlighted_cards({ G.hand }, card, 1, card.ability.extra.cards)
        local first_card = highlighted[1]
        vallkarri.do_while_flipped(highlighted, function(ca)
            copy_card(first_card, ca)
            G.hand:remove_from_highlighted(ca)
        end)

        highlighted[1]:set_ability("m_steel")
        highlighted[1]:juice_up()
    end,
    soul_rate = vallkarri.merged_tarot_rate,
    hidden = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end

}


SMODS.Consumable {
    key = "the_pope",
    set = "Tarot",
    loc_txt = {
        name = "The Pope",
        text = {
            "Give all cards {C:attention}held-in-hand{}",
            "the same random {C:attention}vanilla enhancement{} and {C:attention}edition{}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = {} },
    atlas = "main",
    pos = { x = 11, y = 0, },
    no_grc = true,

    loc_vars = function(self, info_queue, card)

    end,
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,

    use = function(self, card, area, copier)
        local moptions = { "m_bonus", "m_mult", "m_wild", "m_glass", "m_steel", "m_stone", "m_gold", "m_lucky" }
        local eoptions = { "e_foil", "e_holo", "e_polychrome", "e_negative" }

        local choices = {
            enhancement = moptions[pseudorandom("pope_enh", 1, #moptions)],
            edition = eoptions[pseudorandom("pope_edi", 1, #eoptions)]
        }

        vallkarri.do_while_flipped(G.hand.cards, function(card)
            card:set_ability(choices.enhancement)
            card:set_edition(choices.edition, true)
        end)
    end,
    soul_rate = vallkarri.merged_tarot_rate,
    hidden = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end

}

SMODS.Consumable {
    key = "gods_finger",
    set = "Tarot",
    loc_txt = {
        name = "God's Fingers",
        text = {
            "Select up to {C:attention}#1#{} cards,",
            "{C:red}destroy{} all selected cards and create a ",
            "{C:dark_edition}Negative{} {C:rare}rare{} {C:attention}Joker{} for each card destroyed",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { cards = 2 } },
    atlas = "main",
    pos = { x = 12, y = 0, },
    no_grc = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return { vars = { card.ability.extra.cards } }
    end,
    can_use = function(self, card)
        local highlighted = Cryptid.get_highlighted_cards({ G.hand }, card, 1, card.ability.extra.cards)
        return #highlighted > 0 and #highlighted <= card.ability.extra.cards
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                for i, c in ipairs(Cryptid.get_highlighted_cards({ G.hand }, card, 1, card.ability.extra.cards)) do
                    c:start_dissolve({ G.C.BLACK }, nil, 2 * G.SETTINGS.GAMESPEED)
                    local joker = create_card("Joker", G.jokers, nil, 3, nil, nil, nil, "valk_godsfinger")
                    joker:add_to_deck()

                    G.jokers:emplace(joker)
                    joker:set_edition("e_negative", true)
                end
                return true
            end
        }))
    end,
    soul_rate = vallkarri.merged_tarot_rate,
    hidden = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end

}

SMODS.Consumable {
    key = "the_killer",
    set = "Tarot",
    loc_txt = {
        name = "The Killer",
        text = {
            "Create {C:attention}#1#{} Negative {C:tarot}Tarot{} for",
            "every {C:attention}#2#{} {C:tarot}Tarot{} cards used in run",
            "{C:inactive}(Currently #3#){}",
        }
    },
    config = { extra = { per = 1, req = 3 } },
    atlas = "main",
    pos = { x = 10, y = 1, },
    no_grc = true,
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        local sum = 0
        for i, amt in pairs(G.GAME.consumeable_usage) do
            if G.GAME.consumeable_usage[i].set and G.GAME.consumeable_usage[i].set == "Tarot" then
                sum = sum + G.GAME.consumeable_usage[i].count
            end
        end

        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.req,
                math.floor(sum / card.ability.extra.req) * card.ability.extra.per
            }
        }
    end,
    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local sum = 0
        for i, amt in pairs(G.GAME.consumeable_usage) do
            if G.GAME.consumeable_usage[i].set and G.GAME.consumeable_usage[i].set == "Tarot" then
                sum = sum + G.GAME.consumeable_usage[i].count
            end
        end

        -- SMODS.add_card({ set = "Tarot", edition = "e_negative", area = G.consumeables })

        local count = math.floor(sum / card.ability.extra.req) * card.ability.extra.per

        for i = 1, count do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.1,
                func = function()
                    local c = SMODS.add_card({ set = "Tarot", edition = "e_negative", area = G.consumeables })
                    c:juice_up()
                    play_sound("tarot1")
                    return true
                end
            }))
        end
    end,
    soul_rate = vallkarri.merged_tarot_rate,
    hidden = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end

}

SMODS.Consumable {
    key = "gameshow",
    set = "Tarot",
    loc_txt = {
        name = "Gameshow",
        text = {
            "Each Joker has a {C:green}#1# in [Sell Value]{} chance to",
            "multiply all its values by its {C:money}Sell Value{}",
        }
    },
    config = { extra = {} },
    atlas = "main",
    pos = { x = 11, y = 1, },
    no_grc = true,
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        local num, blank = SMODS.get_probability_vars(card, 1, 1, 'valk_gameshow')
        return {
            vars = {
                num
            }
        }
    end,
    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        for i, joker in ipairs(G.jokers.cards) do
            if SMODS.pseudorandom_probability(card, 'valk_gameshow', 1, math.abs(joker.sell_cost)) then
                vallkarri.do_while_flipped({ joker }, function(c)
                    Cryptid.manipulate(c, { value = c.sell_cost })
                end)
            end
        end
    end,
    soul_rate = vallkarri.merged_tarot_rate,
    hidden = true,


    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    key = "the_knight",
    set = "Tarot",
    loc_txt = {
        name = "The Knight",
        text = {
            "Select up to {C:attention}#1#{} cards,",
            "apply a random {C:attention}CCD{} to all selected cards",
        }
    },
    config = { extra = { cards = 5 } },
    atlas = "main",
    pos = { x = 12, y = 1, },
    no_grc = true,
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards
            }
        }
    end,
    can_use = function(self, card)
        local highlighted = Cryptid.get_highlighted_cards({ G.hand }, card, 1, card.ability.extra.cards)
        return #highlighted > 0 and #highlighted <= card.ability.extra.cards
    end,

    use = function(self, card, area, copier)
        vallkarri.do_while_flipped(vallkarri.get_ordered_highlighted(G.hand), function(c)
            c:set_ability(Cryptid.random_consumable("valk_knight"), true, nil)
            G.hand:remove_from_highlighted(c)
        end)
    end,
    soul_rate = vallkarri.merged_tarot_rate,
    hidden = true,
    dependencies = { "Cryptid" },

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}
