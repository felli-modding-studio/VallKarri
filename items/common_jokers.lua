VALK.UTILS.Joker {
    order = 4,
    key = "suckit",
    valk_artist = "Pangaea",
    config = { extra = {n = 1, d = 50, money = 10} },
    rarity = 1,
    atlas = "jokers",
    pos = { x = 8, y = 0 },
    cost = 0,
    pools = { ["Meme"] = true },

    remove_from_deck = function(self, card, from_debuff)
        if G.jokers then
            if SMODS.pseudorandom_probability(card, "suck_it", card.ability.extra.n, card.ability.extra.d) then
                ease_dollars(card.ability.extra.money)
            else
                local new = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk2_suckit", "suckit")
                new.sell_cost = 0
                new:add_to_deck()
                G.jokers:emplace(new)
            end
            
        end
    end,
    loc_vars = function(self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, card.ability.extra.n, card.ability.extra.d)
        return {vars = {n,d,card.ability.extra.money}}
    end,
    calculate = function(self, card, context)
        if context.forcetrigger then 
            if SMODS.pseudorandom_probability(card, "suck_it", card.ability.extra.n, card.ability.extra.d) then
                ease_dollars(card.ability.extra.money)
            else
                local new = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk2_suckit", "suckit")
                new.sell_cost = 0
                new:add_to_deck()
                G.jokers:emplace(new)
            end
        end
    end,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 5,
    key = "antithesis",
    valk_artist = "mailingway",
    config = { extra = { per = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "jokers",
    pos = { x = 9, y = 0 },
    cost = 5,
    blueprint_compat = true,


    calculate = function(self, card, context)
        if (context.individual and context.cardarea == "unscored") or context.forcetrigger then
            return { mult = card.ability.extra.per }
        end
    end,
    demicoloncompat = true
}

VALK.UTILS.Joker {
    order = 6,
    key = "kitty",
    valk_artist = "mailingway",
    config = { extra = { num = 1, den = 2 } },
    loc_vars = function(self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "kitty")
        return { vars = { n,d } }
    end,
    rarity = 1,
    atlas = "jokers",
    pos = { x = 10, y = 0 },
    cost = 5,
    blueprint_compat = true,
    pools = { ["Kitties"] = true },

    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval and 
            SMODS.pseudorandom_probability(card, "valk_kitty", card.ability.extra.num, card.ability.extra.den, "valk_kitty")) or context.forcetrigger then
            add_tag(Tag("tag_valk2_kitty"))
            return {
                message = localize("k_plus_kitty_tag")
            }
        end
    end,
    demicoloncompat = true
}

VALK.UTILS.Joker {
    order = 7,
    key = "fancy_joker",
    valk_artist = "mailingway",
    config = { extra = { per = 6 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "jokers",
    pos = { x = 0, y = 1 },
    cost = 3,
    blueprint_compat = true,


    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.hand and next(SMODS.get_enhancements(context.other_card)) and not context.end_of_round) or context.forcetrigger then
            return {mult = card.ability.extra.per}
        end
    end,
    demicoloncompat = true
}

VALK.UTILS.Joker {
    order = 8,
    key = "posh_joker",
    valk_artist = "mailingway",
    config = { extra = { per = 25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "jokers",
    pos = { x = 1, y = 1 },
    cost = 3,
    blueprint_compat = true,


    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.hand and next(SMODS.get_enhancements(context.other_card)) and not context.end_of_round) or context.forcetrigger then
            return {chips = card.ability.extra.per}
        end
    end,
    demicoloncompat = true
}