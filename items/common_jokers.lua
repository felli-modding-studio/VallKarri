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
    demicolon_compat = true
}