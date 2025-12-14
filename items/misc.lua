SMODS.PokerHand {
    key = "full_mansion",
    mult = 20,
    chips = 400,
    l_mult = 10,
    l_chips = 150,
    visible = false,
    example = {
        {"S_9"},
        {"H_9"},
        {"D_9"},
        {"S_T"},
        {"C_T"},
        {"H_T"},
        {"C_T"},
    },
    visible = false,
    evaluate = function(parts, hand)
        if #parts._3 >= 2 and #parts._4 >= 1 then return parts._all_pairs end
        return {}
    end
}

VALK.UTILS.Joker {
    order = 1,
    key = "homely_joker",
    valk_artist = "Pangaea",
    config = {extra = {mult = 60}},
    rarity = 1,
    atlas = "jokers",
    pos = {x=0, y=0},
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

        if (context.joker_main and context.poker_hands ~= nil and next(context.poker_hands["valk2_full_mansion"])) or context.forcetrigger then
            return {
                mult = card.ability.extra.mult
            }
        end

    end,
    in_pool = function()
        return G.GAME.hands["valk2_full_mansion"].played > 0
    end,
    demicolon_compat = true
}

VALK.UTILS.Joker {
    order = 2,
    key = "roomy_joker",
    valk_artist = "Pangaea",
    config = {extra = {chips = 600}},
    rarity = 1,
    atlas = "jokers",
    pos = {x=1, y=0},
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)

        if (context.joker_main and context.poker_hands ~= nil and next(context.poker_hands["valk2_full_mansion"])) or context.forcetrigger then
            return {
                chips = card.ability.extra.chips
            }
        end

    end,
    in_pool = function()
        return G.GAME.hands["valk2_full_mansion"].played > 0
    end,
    demicolon_compat = true
}

VALK.UTILS.Joker {
    order = 3,
    key = "the_home",
    valk_artist = "Pangaea",
    config = {extra = {mult = 9}},
    rarity = 3,
    atlas = "jokers",
    pos = {x=9, y=4},
    cost = 8,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

        if (context.joker_main and context.poker_hands ~= nil and next(context.poker_hands["valk2_full_mansion"])) or context.forcetrigger then
            return {
                xmult = card.ability.extra.mult
            }
        end

    end,
    in_pool = function()
        return G.GAME.hands["valk2_full_mansion"].played > 0
    end,
    demicolon_compat = true
}