SMODS.Joker {
    key = "suckit",
    loc_txt = {
        name = "{C:red}Suck It{}",
        text = {
            "Creates itself when removed",
            "{C:green}#1# in #2#{} chance to not come back,",
            "and give {C:money}$#3#{}",
        }
    },
    valk_artist = "Pangaea",
    config = { extra = {n = 1, d = 50, money = 10} },
    rarity = 1,
    atlas = "main",
    pos = { x = 4, y = 5 },
    cost = 0,
    pools = { ["Meme"] = true },

    remove_from_deck = function(self, card, from_debuff)
        if G.jokers then
            if SMODS.pseudorandom_probability(card, "suck_it", card.ability.extra.n, card.ability.extra.d) then
                ease_dollars(card.ability.extra.money)
            else
                local new = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk_suckit", "suckit")
                new.sell_cost = 0
                new:add_to_deck()
                G.jokers:emplace(new)
            end
            
        end
    end,
    loc_vars = function(self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, card.ability.extra.n, card.ability.extra.d)
        return {vars = {n,d,card.ability.extra.money}}
    end
}

SMODS.Joker {
    key = "antithesis",
    loc_txt = {
        name = "Antithesis",
        text = {
            "{C:mult}+#1#{} Mult for every {C:attention}unscoring{} card",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "main",
    pos = { x = 10, y = 5 },
    cost = 5,
    blueprint_compat = true,


    calculate = function(self, card, context)
        if context.joker_main then
            local amount = (#context.full_hand - #context.scoring_hand)
            return { mult = card.ability.extra.per * amount }
        end
    end,
}

SMODS.Joker {
    key = "kitty",
    loc_txt = {
        name = "Kitty",
        text = {
            "At end of round, {C:green}#1# in #2#{} chance",
            "to create a {C:attention}Kitty Tag{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { num = 1, den = 2 } },
    loc_vars = function(self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "kitty")
        return { vars = { n,d } }
    end,
    rarity = 1,
    atlas = "atlas2",
    pos = { x = 2, y = 3 },
    cost = 5,
    blueprint_compat = true,
    pools = { ["Kitties"] = true },

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and 
            SMODS.pseudorandom_probability(card, "valk_kitty", card.ability.extra.num, card.ability.extra.den, "valk_kitty") then
            add_tag(Tag("tag_valk_kitty"))
        end
    end,

}

SMODS.Joker {
    key = "fancyjoker",
    loc_txt = {
        name = "Fancy Joker",
        text = {
            "{C:mult}+#1#{} Mult for every ",
            "{C:attention}Enhanced{} card {C:attention}held-in-hand{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 6 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "atlas2",
    pos = { x = 5, y = 3 },
    cost = 3,
    blueprint_compat = true,


    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and next(SMODS.get_enhancements(context.other_card)) then
            return {mult = card.ability.extra.per}
        end
    end,
}

SMODS.Joker {
    key = "poshjoker",
    loc_txt = {
        name = "Posh Joker",
        text = {
            "{C:chips}+#1#{} Chips for every ",
            "{C:attention}Enhanced{} card {C:attention}held-in-hand{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { per = 25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "atlas2",
    pos = { x = 6, y = 3 },
    cost = 3,
    blueprint_compat = true,


    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and next(SMODS.get_enhancements(context.other_card)) then
            return {chips = card.ability.extra.per}
        end
    end,
}