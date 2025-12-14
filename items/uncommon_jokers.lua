VALK.UTILS.Joker {
    order = 9,
    key = "whereclick",
    valk_artist = "Lily Felli",
    config = { extra = { cur = 1, gain = 0.2, loss = -0.1 } },
    rarity = 2,
    atlas = "jokers",
    pos = { x = 2, y = 1 },
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

VALK.UTILS.Joker {
    order = 10,
    key = "streetlight",
    valk_artist = "Scraptake",
    config = { extra = { cur = 1, gain = 0.2, cap = 5 } },
    rarity = 2,
    atlas = "jokers",
    pos = { x = 3, y = 1 },
    cost = 6,
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
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

VALK.UTILS.Joker {
    order = 11,
    key = "periapt_beer",
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        info_queue[#info_queue + 1] = G.P_TAGS.tag_charm
    end,
    atlas = "jokers",
    pos = { x = 4, y = 1 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self or context.forcetrigger then
            add_tag(Tag("tag_charm"))
            local fool = SMODS.create_card({ key = "c_fool" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
    eternal_compat = false,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 12,
    key = "stellar_yogurt",
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        info_queue[#info_queue + 1] = G.P_TAGS.tag_meteor
    end,
    atlas = "jokers",
    pos = { x = 5, y = 1 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self or context.forcetrigger then
            add_tag(Tag("tag_meteor"))
            local fool = SMODS.create_card({ key = "c_fool" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
    eternal_compat = false,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 13,
    key = "hexed_spirit",
    valk_artist = "Pangaea",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_ethereal
    end,
    atlas = "jokers",
    pos = { x = 6, y = 1 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self or context.forcetrigger then
            add_tag(Tag("tag_ethereal"))
            add_tag(Tag("tag_ethereal"))
        end
    end,
    eternal_compat = false,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 14,
    key = "amber",
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "jokers",
    pos = { x = 7, y = 1 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand or {}) do
                if pcard:is_suit("Diamonds") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 15,
    key = "blackjack",
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "jokers",
    pos = { x = 8, y = 1 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand or {}) do
                if pcard:is_suit("Spades") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 16,
    key = "troupe",
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "jokers",
    pos = { x = 9, y = 1 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand or {}) do
                if pcard:is_suit("Clubs") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 16,
    key = "valentine",
    valk_artist = "mailingway",
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "jokers",
    pos = { x = 10, y = 1 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand or {}) do
                if pcard:is_suit("Hearts") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
    demicoloncompat = true,
}

VALK.UTILS.Joker {
    order = 17,
    key = "rocky",
    valk_artist = "lord.ruby",
    config = { extra = { per = 0.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "jokers",
    pos = { x = 0, y = 2 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand or {}) do
                if Entropy and Entropy.true_suitless(pcard) or SMODS.has_no_suit(pcard) then
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
    demicoloncompat = true
}