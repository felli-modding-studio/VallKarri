SMODS.Joker {
    key = "animblue",
    loc_txt = {
        name = "{C:blue}Blue{}",
        text = {
            "Increase the values of all Jokers",
            " by {C:attention}+#1#{} at end of round",
        }
    },
    valk_artist = "Scraptake",
    loc_vars = function(self, info_queue, card )
        return {vars = {card.ability.extra.change}}
    end,
    
    config = { extra = {change = 0.25} },
    rarity = 3,
    atlas = "main",
    pos = {x=5, y=3},
    soul_pos = {x=6, y=3},
    immutable = true,
    cost = 10,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval) then

            for i,joker in ipairs(G.jokers.cards) do
                
                if joker ~= card then
                    Cryptid.manipulate(joker, {value = card.ability.extra.change, operation = "+"})
                end
            
            end

        end
    end
}

SMODS.Joker {
    key = "animyellow",
    loc_txt = {
        name = "{C:money}Yellow{}",
        text = {
            "Create a {C:dark_edition}Negative{} {C:attention}Consumable{} when any",
            "{C:tarot}Tarot{} card is sold",
        }
    },
    valk_artist = "Scraptake",
    loc_vars = function(self, info_queue, card )
        
    end,
    
    config = { extra = {} },
    rarity = 3,
    atlas = "main",
    pos = {x=5, y=7},
    soul_pos = {x=6, y=7},
    immutable = true,
    cost = 12,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if (context.selling_card and context.card.ability and context.card.ability.set == "Tarot") or context.forcetrigger then

            local not_a_codecard = SMODS.create_card({set = "Consumeables", edition = "e_negative"})
            not_a_codecard:add_to_deck()
            G.consumeables:emplace(not_a_codecard)
        end

    end
}

SMODS.Joker {
    key = "animorange",
    loc_txt = {
        name = "{C:attention}Orange{}",
        text = {
            "Create a random {C:dark_edition}Negative{} {C:attention}Consumable{} for each unscoring card played",
        }
    },
    valk_artist = "Scraptake",
    loc_vars = function(self, info_queue, card )

    end,
    
    config = { extra = {} },
    rarity = "valk_renowned",
    atlas = "main",
    pos = {x=5, y=5},
    soul_pos = {x=6, y=5},
    immutable = true,
    cost = 12,
    blueprint_compat = true,
    calculate = function(self, card, context)

        if context.before then
            local amount = (#context.full_hand - #context.scoring_hand)
            for i=1,amount do
                local c = SMODS.create_card({set = "Consumeables", edition = "e_negative"})
                c:add_to_deck()
                G.consumeables:emplace(c)
            end

        end

    end
}