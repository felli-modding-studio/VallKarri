SMODS.Joker {
    key = "whereclick",
    loc_txt = {
        name = "{C:red}Where do I click?{}",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when a card is sold",
            "Loses {X:mult,C:white}X#2#{} Mult when a {C:attention}Consumable{} is used",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult){}",
            "{C:inactive}Where do I click, Drago?{}",
        }
    },
    valk_artist = "Lily Felli",
    config = { extra = { cur = 1, gain = 0.2, loss = -0.1 } },
    rarity = 2,
    atlas = "main",
    pos = { x = 4, y = 6 },
    cost = 6,
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, -card.ability.extra.loss, card.ability.extra.cur } }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable then --fucking whatever
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "cur", scalar_value = "loss"})
        end

        if context.selling_card then
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "cur", scalar_value = "gain"})
        end

        if context.joker_main or context.forcetrigger then
            return { xmult = card.ability.extra.cur }
        end
    end
}

SMODS.Joker {
    key = "streetlight",
    loc_txt = {
        name = "Streetlight",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when an {C:attention}Enhanced{} card scores",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { cur = 1, gain = 0.2, cap = 5 } },
    rarity = 2,
    atlas = "main",
    pos = { x = 5, y = 8 },
    cost = 6,
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_valk_mirrored
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card)) then
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "cur", scalar_value = "gain"})
        end

        if context.joker_main then
            return { xmult = card.ability.extra.cur }
        end
    end

}

SMODS.Joker {
    key = "periapt_beer",
    loc_txt = {
        name = "Periapt Beer",
        text = {
            "Create a {C:tarot}Charm Tag{} and {C:attention}The Fool{} when sold",
        }
    },
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        info_queue[#info_queue + 1] = G.P_TAGS.tag_charm
    end,
    atlas = "main",
    pos = { x = 5, y = 11 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_charm"))
            local fool = SMODS.create_card({ key = "c_fool" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
    eternal_compat = false,
}

SMODS.Joker {
    key = "stellar_yogurt",
    loc_txt = {
        name = "Stellar Yogurt",
        text = {
            "Create a {C:planet}Meteor Tag{} and {C:attention}The Fool{} when sold",
        }
    },
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        info_queue[#info_queue + 1] = G.P_TAGS.tag_meteor
    end,
    atlas = "main",
    pos = { x = 6, y = 11 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_meteor"))
            local fool = SMODS.create_card({ key = "c_fool" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
    eternal_compat = false,
}

SMODS.Joker {
    key = "hexed_spirit",
    loc_txt = {
        name = "Hexed Spirit",
        text = {
            "Create two {C:spectral}Ethereal Tags{} when sold",
        }
    },
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_ethereal
    end,
    atlas = "main",
    pos = { x = 7, y = 11 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_ethereal"))
            add_tag(Tag("tag_ethereal"))
        end
    end,
    eternal_compat = false,
}

SMODS.Joker {
    key = "amber",
    loc_txt = {
        name = "Amber",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:diamonds}Diamond{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 10, y = 6 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Diamonds") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "blackjack",
    loc_txt = {
        name = "Blackjack",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:spades}Spade{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 11, y = 6 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Spades") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "troupe",
    loc_txt = {
        name = "Troupe",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:spades}Club{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 10, y = 7 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Clubs") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "valentine",
    loc_txt = {
        name = "Valentine",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:hearts}Heart{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 11, y = 7 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Hearts") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "rocky",
    loc_txt = {
        name = "Rocky",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:attention}Suitless{} card",
        }
    },
    valk_artist = "lord.ruby",
    config = { extra = { per = 0.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "atlas2",
    pos = { x = 1, y = 2 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if Entropy and Entropy.true_suitless(card) or SMODS.has_no_suit(card) then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    in_pool = function(self, args)
        for i,card in ipairs(G.playing_cards) do
            if Entropy and Entropy.true_suitless(card) or SMODS.has_no_suit(card) then
                return true
            end
        end
        return false
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "utteredchaos",
    loc_txt = {
        name = "Uttered Chaos",
        text = {
            "{C:mult}+#1#{} Mult for every character in the",
            "most recent message sent in the {C:attention}VallKarri{} discord server",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
            "{C:inactive,s:0.6,E:1}\"#3#\"",
            "{V:1,S:0.5}https://discord.gg/5d3HWu88yn{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per, #vallkarri.last_message * card.ability.extra.per, vallkarri.last_message, colours = {
                HEX("7289DA")
            } } }
    end,
    atlas = "main",
    pos = { x = 12, y = 5 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = (card.ability.extra.per * #vallkarri.last_message) }
        end
    end,

    update = function(self, card, dt)
        if card and card.children and math.random(1, 5) == 1 then
            card.children.center:set_sprite_pos({ x = math.random(12, 13), y = 5 })
        end
    end
}

SMODS.Joker {
    key = "planedolia",
    loc_txt = {
        name = "Planedolia",
        text = {
            "{C:planet}Planet{} cards have a {C:green}#1#%{} chance",
            "to replace any other spawned card",
        }
    },
    valk_artist = "triangle_snack",
    config = { extra = { chance = 15 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chance } }
    end,
    atlas = "main",
    pos = { x = 8, y = 12 },
    cost = 6,
    rarity = 2,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.planet_replace = G.GAME.planet_replace and (G.GAME.planet_replace + card.ability.extra.chance) or
            card.ability.extra.chance
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.planet_replace = G.GAME.planet_replace and (G.GAME.planet_replace - card.ability.extra.chance) or 0
    end,
}

SMODS.Joker {
    key = "tarodolia",
    loc_txt = {
        name = "Tarodolia",
        text = {
            "{C:tarot}Tarot{} cards have a {C:green}#1#%{} chance",
            "to replace any other spawned card",
        }
    },
    valk_artist = "triangle_snack",
    config = { extra = { chance = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chance } }
    end,
    atlas = "main",
    pos = { x = 10, y = 12 },
    cost = 6,
    rarity = 2,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.tarot_replace = G.GAME.tarot_replace and (G.GAME.tarot_replace + card.ability.extra.chance) or
            card.ability.extra.chance
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.tarot_replace = G.GAME.tarot_replace and (G.GAME.tarot_replace - card.ability.extra.chance) or 0
    end,
}

SMODS.Joker {
    key = "spectradolia",
    loc_txt = {
        name = "Spectradolia",
        text = {
            "{C:spectral}Spectral{} cards have a {C:green}#1#%{} chance",
            "to replace any other spawned card",
        }
    },
    valk_artist = "triangle_snack",
    config = { extra = { chance = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chance } }
    end,
    atlas = "main",
    pos = { x = 9, y = 12 },
    cost = 6,
    rarity = 2,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.spectral_replace = G.GAME.spectral_replace and (G.GAME.spectral_replace + card.ability.extra.chance) or
            card.ability.extra.chance
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.spectral_replace = G.GAME.spectral_replace and (G.GAME.spectral_replace - card.ability.extra.chance) or 0
    end,
}

SMODS.Joker {
    key = "merchantcat",
    rarity = 2,
    atlas = "atlas2",
    pos = { x = 3, y = 1 },
    cost = 8,
    loc_txt = {
        name = "Merchant Cat",
        text = {
            "Create a {C:attention}Kitty Tag{} when a card is bought",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    demicoloncompat = true,
    config = { extra = {} },
    calculate = function(self, card, context)
        if context.buying_card then
            add_tag(Tag("tag_valk_kitty"))
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "roundabout",
    rarity = 2,
    atlas = "main",
    pos = { x = 12, y = 8 },
    cost = 8,
    loc_txt = {
        name = "Roundabout",
        text = {
            "{C:attention}-#1#{} to the next change in ante",
            "{C:red,E:1}Self-destructs{}",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.change } }
    end,
    demicoloncompat = true,
    config = { extra = { change = 1 } },
    calculate = function(self, card, context)
        if context.modify_ante then
            card:start_dissolve({ G.C.BLACK }, false)
            return { modify = -card.ability.extra.change }
        end
    end,

}

SMODS.Joker {
    key = "chipless_cookie",
    rarity = 2,
    atlas = "main",
    pos = { x = 13, y = 7 },
    cost = 8,
    loc_txt = {
        name = "Chipless Cookie",
        text = {
            "{C:attention}+#1#{} Joker Slots",
            "{C:red,E:1}Self-destructs{} if played hand is not",
            "most played {C:attention}poker hand{}",
            "{C:inactive}(Currently #2#)",
        }
    },
    valk_artist = "mailingway",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, vallkarri.get_most_played_hand() } }
    end,
    config = { extra = { slots = 2 } },
    calculate = function(self, card, context)
        if context.before then
            if not (context.scoring_name == vallkarri.get_most_played_hand()) then
                card:start_dissolve({G.C.RED})
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers:change_size(card.ability.extra.slots)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers:change_size(-card.ability.extra.slots)
    end,

}

SMODS.Joker {
    key = "take_your_age",
    rarity = 2,
    atlas = "phold",
    pos = { x = 0, y = 1 },
    cost = 8,
    loc_txt = {
        name = "Take your age...",
        text = {
            "{C:mult}+#1#{} Mult for each Mod installed",
            "Increase by {C:mult}+#3#{} Mult at end of round",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        }
    },
    valk_artist = nil,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.total / vallkarri.mods_installed(), card.ability.extra.total, card.ability.extra.gain / vallkarri.mods_installed() } }
    end,
    config = { extra = { total = 10, gain = 5 } },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.total
            }
        end

        if context.end_of_round and context.main_eval then
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "total", scalar_value = "gain"})
        end
    end,

}


SMODS.Joker {
    key = "trump_casino",
    rarity = 2,
    atlas = "phold",
    pos = { x = 0, y = 1 },
    cost = 8,
    loc_txt = {
        name = {"Joker starts", "giving out", "$2,222 to", "everyone!"},
        text = {
            "Earn {C:money}$#1#{} when a {C:attention}2{} is scored",
            "Lose {C:money}$#2#{} when entering Shop",
        }
    },
    valk_artist = nil,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.earn, card.ability.extra.loss } }
    end,
    config = { extra = { earn = 2.22, loss = 2 } },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 then
            return {
                dollars = card.ability.extra.earn
            }
        end

        if context.starting_shop then
            G.E_MANAGER:add_event(Event({
                func = function()

                    ease_dollars(card.ability.extra.loss)
                    card:juice_up()
                    return true
                end
            }))
            
        end
    end,

}
