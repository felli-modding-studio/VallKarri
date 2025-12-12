SMODS.Joker {
    key = "planetarium",
    loc_txt = {
        name = "Planetarium",
        text = {
            "When {C:attention}hand{} played, increase {C:chips}Chips{} and {C:mult}Mult{} per level",
            "of played {C:attention}poker hand{} by {C:attention}#1#{}",
        }
    },
    valk_artist = "Grahkon",
    config = { extra = { inc = 1 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.inc
            }
        }
    end,
    atlas = "main",
    pos = { x = 10, y = 4 },
    cost = 7,
    rarity = 3,
    calculate = function(self, card, context)
        if context.before then
            quick_card_speak(card, localize("k_upgrade_ex"))
            local text = G.FUNCS.get_poker_hand_info(context.full_hand)
            G.GAME.hands[text].l_chips = G.GAME.hands[text].l_chips + card.ability.extra.inc
            G.GAME.hands[text].l_mult = G.GAME.hands[text].l_mult + card.ability.extra.inc
        end
    end,
}

SMODS.Joker {
    key = "matchbox",
    loc_txt = {
        name = "Matchbox",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult per",
            "{C:attention}consecutive{} hand played larger than blind size",
            "{C:inactive}(Does not reset on Boss Blinds){}",
            "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult){}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { cur = 1, gain = 0.3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 4, y = 13 },
    cost = 8,
    blueprint_compat = true,


    calculate = function(self, card, context)
        -- is a little fucked with The Tax boss blind but idk how to fix, help
        if context.after then
            if to_big(SMODS.calculate_round_score()) > to_big(G.GAME.blind.chips) then
                card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
                quick_card_speak(card, "Upgraded!")
            else
                if not G.GAME.blind.boss then
                    card.ability.extra.cur = 1
                    quick_card_speak(card, "Reset!")
                end
            end
        end

        if context.joker_main or context.forcetrigger then
            return { xmult = card.ability.extra.cur }
        end
    end,

}

SMODS.Joker {
    key = "legeater",
    loc_txt = {
        name = "Leg-Eater",
        text = {
            "Creates a copy of the {C:attention}topmost{} tag when blind selected",
            "Lose {C:money}$#1#{} when this happens",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { money = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 5, y = 1 },
    soul_pos = { x = 6, y = 1 },
    cost = 15,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.setting_blind or context.forcetrigger) and #G.GAME.tags > 0 then
            add_tag(Tag(G.GAME.tags[#G.GAME.tags].key))
            ease_dollars(-card.ability.extra.money)
        end
    end
}

SMODS.Joker {
    key = "familiarface",
    loc_txt = {
        name = "Familiar Face",
        text = {
            "Scored {C:attention}9s{} give {X:mult,C:white}X#1#{} Mult",
            "Scored {C:attention}Mirrored{} cards give {X:chips,C:white}X#2#{} Chips",
            "{C:inactive,s:0.7}hm, where have i seen this face before?",
        }
    },
    valk_artist = "aduckted",
    config = { extra = { xmult = 1.09, xchips = 2.9 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_valk_mirrored
        return { vars = { card.ability.extra.xmult, card.ability.extra.xchips } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 11, y = 8 },
    cost = 8,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local returntable = {}
            if SMODS.has_enhancement(context.other_card, "m_valk_mirrored") then
                returntable.xchips = card.ability.extra.xchips
            end
            if context.other_card:get_id() == 9 then
                returntable.xmult = card.ability.extra.xmult
            end

            return returntable
        end
    end
}

-- {x=10, y=8}

SMODS.Joker {
    key = "neffy",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 2, y = 1 },
    cost = 8,
    loc_txt = {
        name = "Neffy",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Lose {X:mult,C:white}X#2#{} for every other {C:attention}Kitty{} Joker owned",
            catby("cg")
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.base - math.max(kitty_count(-1) * card.ability.extra.loss, 0), card.ability.extra.loss } }
    end,
    demicoloncompat = true,
    config = { extra = { base = 3, loss = 0.25 } },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.base - math.max(kitty_count(-1) * card.ability.extra.loss, 0)
            }
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "norma",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 2, y = 0 },
    cost = 8,
    loc_txt = {
        name = "Norma",
        text = {
            "Cards in hand are {C:attention}flipped{} when cards are drawn",
            "Gain {X:mult,C:white}X#1#{} Mult for each card drawn",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            catby("Ren")
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.xmult } }
    end,
    demicoloncompat = true,
    config = { extra = { xmult = 1, gain = 0.03, real_gain = 0 } },
    calculate = function(self, card, context)
        if context.drawing_cards then
            card.ability.extra.real_gain = (card.ability.extra.gain * context.amount)
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.real_gain

            SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "real_gain" })

            for i, handcard in ipairs(G.hand.cards) do
                handcard:flip()
            end
        end

        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "boxofkittens",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 3, y = 2 },
    cost = 8,
    loc_txt = {
        name = "Box of Kittens",
        text = {
            "Create a {C:attention}Kitty Tag{} when rerolling the shop",
            "{C:mult}+#1#{} Mult for each {C:attention}Kitty Tag{} owned",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult * vallkarri.count_kitty_tags() } }
    end,
    demicoloncompat = true,
    config = { extra = { mult = 3 } },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra.mult * vallkarri.count_kitty_tags()
            }
        end

        if context.reroll_shop then
            add_tag(Tag("tag_valk_kitty"))
        end
    end,
    pools = { ["Kitties"] = true },
    blueprint_compat = true,
}

SMODS.Joker {
    key = "dupli_cat_ion",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 3, y = 3 },
    cost = 8,
    loc_txt = {
        name = "Dupli-cat-ion",
        text = {
            "At end of round, each {C:attention}Kitty Tag{} has a {C:green}#1# in #2#{}",
            "chance to create another {C:attention}Kitty Tag{}",
            "Increase denominator by {C:attention}#3#{} for every {C:attention}#4# Kitty Tags{} owned",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.base_num,
            card.ability.extra.base_den + math.floor(vallkarri.count_kitty_tags() / card.ability.extra.thresh))

        return { vars = { num, den, card.ability.extra.inc, card.ability.extra.thresh } }
    end,
    demicoloncompat = true,
    config = { extra = { base_num = 1, base_den = 2, inc = 1, thresh = 4 } },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local to_make = 0

            for i, tag in ipairs(G.GAME.tags) do
                if tag.key == "tag_valk_kitty" then
                    if SMODS.pseudorandom_probability(card, "duplication", card.ability.extra.base_num, card.ability.extra.base_den + math.floor(vallkarri.count_kitty_tags() / card.ability.extra.thresh)) then
                        to_make = to_make + 1
                    end
                end
            end

            for i = 1, to_make do
                add_tag(Tag("tag_valk_kitty"))
            end
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "greedy_bastard",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 2, y = 2 },
    cost = 8,
    loc_txt = {
        name = "Greedy Bastard",
        text = {
            "At end of round, gain {X:mult,C:white}X#1#{} Mult for each {C:attention}Kitty Tag{} owned",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,
    demicoloncompat = true,
    config = { extra = { mult = 1, gain = 0.05 } },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.mult
            }
        end

        if context.end_of_round and context.main_eval then
            local upgr = false
            for i, tag in ipairs(G.GAME.tags) do
                if tag.key == "tag_valk_kitty" then
                    upgr = true
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                end
            end
            if upgr then
                quick_card_speak(card, localize("k_upgrade_ex"))
            end
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "thecolonthree",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 0, y = 2 },
    cost = 8,
    loc_txt = {
        name = "The :3",
        text = {
            "{X:mult,C:white}X#1#{} Mult {C:attention}3{} times if",
            "{C:attention}#2#{} or more hands have been played this round"
        }
    },
    valk_artist = "notmario",
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.req} }
    end,
    demicoloncompat = true,
    config = { extra = { mult = 3, req = 3} },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and (G.GAME.round_resets.hands - G.GAME.current_round.hands_left) >= card.ability.extra.req) or context.forcetrigger then
            for _=1,3 do 
                SMODS.calculate_effect({xmult = card.ability.extra.mult}, card)
            end
        end
    end,
    pools = { ["Kitties"] = true },

    -- :3
    -- ⋮3

}

SMODS.Joker {
    key = "coronal",
    loc_txt = {
        name = "Coronal Ejection",
        text = {
            "{C:green}#1# in #2#{} chance to increase",
            "{C:gold}Ascension Power{} of played {C:attention}poker hand{} by {X:gold,C:white}+#3#{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { num = 1, den = 10, power = 10 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'coronal')
        return { vars = { num, den, card.ability.extra.power } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 4, y = 14 },
    cost = 8,
    demicoloncompat = true,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.before then
            if SMODS.pseudorandom_probability(card, 'coronal', card.ability.extra.num, card.ability.extra.den, 'coronal') then
                local text = G.FUNCS.get_poker_hand_info(context.full_hand)
                G.GAME.hands[text].AscensionPower = (G.GAME.hands[text].AscensionPower and G.GAME.hands[text].AscensionPower + card.ability.extra.power) or
                    card.ability.extra.power
                quick_card_speak(card, "Upgraded!")
            end
        end
    end,
    dependencies = { "entr" },

}

SMODS.Joker {
    key = "one_trillion_beavers",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 4, y = 2 },
    cost = 8,
    loc_txt = {
        name = "One Trillion Beavers",
        text = {
            "Prevent death once then {C:red,E:1}self destructs{}",
            "{C:attention}Doubles{} your current {C:money}money{} when death is prevented",
        }
    },
    valk_artist = "mailingway",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(G.GAME.dollars)
                    return true
                end
            }))
            return {
                message = localize('k_saved_ex'),
                saved = 'ph_valk_beavers',
                colour = G.C.RED
            }
        end
    end,

}

SMODS.Joker {
    key = "borderline_joker",
    rarity = 3,
    atlas = "main",
    pos = { x = 12, y = 9 },
    cost = 8,
    loc_txt = {
        name = "Borderline Joker",
        text = {
            "{X:chips,C:white}X#1#{} Chips",
            "Increase by {X:chips,C:white}X#2#{} at end of round",
            "Adds a {C:chips}blue border{} which gets {C:attention}#3# pixel(s){}",
            "thicker at end of round",
            "{C:inactive}(Currently {C:attention}#4#{C:inactive} Pixels wide)",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.gain, card.ability.extra.border_width_gain, card.ability.extra.border_width} }
    end,
    config = { extra = { xchips = 1, gain = 0.2, border_width = 5, border_width_gain = 1 } },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xchips = card.ability.extra.xchips
            }
        end

        if context.end_of_round and context.main_eval then
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "xchips", scalar_value = "gain"})
            card.ability.extra.border_width = card.ability.extra.border_width + 1
            quick_card_speak(card, localize("k_upgrade_ex"))
            --i'll use scale_card when it's actually documented <3
            -- or when i learn how it works, as it seems
        end
    end

}

SMODS.Joker {
    key = "copycat",
    rarity = 3,
    loc_txt = {
        name = "Copy Cat",
        text = {
            "When blind selected, add a random",
            "{C:attention}Mirrored{} card to deck",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)

        info_queue[#info_queue+1] = G.P_CENTERS.m_valk_mirrored
        return {
            vars = {

            }
        }
    end,
    config = { extra = {} },
    atlas = "atlas2",
    pos = { x = 3, y = 4 },
    cost = 12,
    immutable = true,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.setting_blind then
            -- code essentially copied frmo marble joker
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = SMODS.create_card({ key = "m_valk_mirrored" })
                    SMODS.calculate_effect({ message = "Created!", colour = G.C.SECONDARY_SET.Enhanced },
                        context.blueprint_card or card)

                    G.deck:emplace(c)
                    table.insert(G.playing_cards, c)
                    return true
                end
            }))
        end
    end,
}