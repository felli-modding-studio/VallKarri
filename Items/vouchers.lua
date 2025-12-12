local decks = {
    ["Red Deck"] = function(redeeming, context)
        if redeeming then SMODS.change_discard_limit(2) end
    end,
    ["Blue Deck"] = function(redeeming, context)
        if redeeming then SMODS.change_play_limit(2) end
    end,
    ["Yellow Deck"] = function(redeeming, context)
        if redeeming then G.GAME.eor_earn = 2
        elseif context.end_of_round and context.main_eval then
            ease_dollars(G.GAME.eor_earn)
        end
    end,
    ["Green Deck"] = function(redeeming, context)
        if redeeming then
            if not G.GAME.modifiers.money_per_discard then
                G.GAME.modifiers.money_per_discard = 0 
            end
            G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard + 1
        end
    end,
    ["Black Deck"] = function(redeeming, context)
        if redeeming then G.GAME.refund_hands = true
        elseif G.GAME.refund_hands and context.before and context.scoring_name and context.scoring_name == vallkarri.get_most_played_hand() then
            ease_hands_played(0.5)
        end
    end,
    ["Magic Deck"] = function(redeeming, context)
        if redeeming then G.GAME.consumable_after_round = true
        elseif G.GAME.consumable_after_round and context.end_of_round and context.main_eval then
            
            local type = pseudorandom("valk_quantum_magicdeck", 1, 2) == 1 and "Spectral" or "Tarot"
            local c = create_card(type, G.consumeables, nil, nil, nil, nil, nil, "valk_quantum_magicdeck")
            c:add_to_deck()
            c:set_edition("e_negative", true)
            G.consumeables:emplace(c)

        end
    end,
    ["Nebula Deck"] = function(redeeming, context)
        if redeeming then G.GAME.consume_planets = true
        elseif G.GAME.consume_planets and context.end_of_round and context.main_eval then

            for i,consumable in ipairs(G.consumeables.cards) do
                if consumable.ability and consumable.ability.hand_type then
                    local amt = Overflow and consumable.ability.immutable.overflow_amount or 1
                    level_up_hand(consumable, consumable.ability.hand_type, nil, amt)
                end
            end

        end
    end,
    ["Ghost Deck"] = function(redeeming, context)
        if redeeming then G.GAME.reroll_consumables = true
        elseif G.GAME.reroll_consumables and context.selling_card and context.card.sell_cost > 0 and context.card.ability.set == "Spectral" then
            local c = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "valk_quantum_magicdeck")
            c:add_to_deck()
            c:set_edition("e_negative", true)
            G.consumeables:emplace(c)
            c.sell_cost = 0
        end
    end,
    ["Abandoned Deck"] = function(redeeming, context)
        if redeeming then G.GAME.suitconvert = true
        elseif G.GAME.suitconvert and context.individual and context.other_card and context.other_card.area == G.play then

            if context.other_card.base.suit == "Clubs" then
                SMODS.change_base(context.other_card, "Spades")
            elseif context.other_card.base.suit == "Diamonds" then
                SMODS.change_base(context.other_card, "Hearts")
            end

        end 
    end,
    ["Checkered Deck"] = function(redeeming, context)
        if redeeming then G.GAME.rankconvert = true
        elseif G.GAME.rankconvert and context.individual and context.other_card and context.other_card.area == G.play then
            -- print("success 1")
            if context.other_card.base.suit == "Spades" then
                -- print("success 2")
                SMODS.change_base(context.other_card, context.other_card.base.suit, "4")
            elseif context.other_card.base.suit == "Hearts" then
                -- print("success 3")
                SMODS.change_base(context.other_card, context.other_card.base.suit, "7")
            end

        end 
    end,
    ["Zodiac Deck"] = function(redeeming, context)
        if redeeming then vallkarri.multiply_all_hand_scaling(3) end
    end,
    ["Painted Deck"] = function(redeeming, context)
        if redeeming then G.GAME.handsize_on_sell = 1
        elseif context.selling_card and context.card.ability.set == "Joker" and context.card.config.center.rarity ~= 1 then
            G.hand:change_size(G.GAME.handsize_on_sell)
        end
    end,
    ["Anaglyph Deck"] = function(redeeming, context)
        if redeeming then G.GAME.doubletag_create = true
        elseif context.setting_blind then

            add_tag(Tag("tag_double"))

        end
    end,
    ["Plasma Deck"] = function(redeeming, context)
        if redeeming then G.GAME.price_mod = 1 end
    end,
    ["Erratic Deck"] = function(redeeming, context)
        if redeeming then G.GAME.randomize_card = true
        elseif G.GAME.randomize_card and context.individual and context.cardarea == G.play and #G.hand.cards > 0 then
            copy_card(
                G.hand.cards[pseudorandom("valk_erratic_quantum", 1, #G.hand.cards)],
                context.other_card
            )
        end
    end,
}

function vallkarri.add_quantum_deck(deckname, func)
    decks[deckname] = func
end

function vallkarri.get_quantum_decks()
    return decks
end

vallkarri.add_quantum_deck("cry-Antimatter", function(redeeming, context)
    if redeeming then
        local i = 0.6
        local time = 1
        for deckname,func in pairs(vallkarri.get_quantum_decks()) do
            i = i + 0.05
            time = math.max(time - 0.08, 0.05)
            if (deckname ~= "cry-Antimatter") then
                func(true)
                basic_text_announce("+ "..deckname, time * G.SETTINGS.GAMESPEED, nil, nil, "gong", i)
                pause_event(time)
            end
        end
    end

    if context then
        for deckname,func in pairs(vallkarri.get_quantum_decks()) do
            if (deckname ~= "cry-Antimatter") then
                func(false, context)
            end
        end
    end
end)

-- this is for crossmod compat, if you'd like to add a deck to compatibility with Quantum Particle
-- simply pass in the name of the deck (capitalization matters) and a function(redeeming, context) which will be called
-- when redeemed and whenever anything happens


-- example:
-- vallkarri.add_quantum_deck("Red Deck", function(redeeming, context) 
--    if redeeming then SMODS:change_discard_limit(2) end
--    end)


SMODS.Voucher {
    key = "quantumparticle",
    atlas = "main",
    pos = {x=7, y=4},
    loc_txt = {
        name = "{C:valk_blue}Quantum Particle{}",
        text = {
            "Severely {C:attention,E:1}enhances{} your deck",
            "{C:inactive,s:0.85}(If applicable){}",
            "{C:inactive,s:0.8}(Is #1##2# on current deck)",
        }
    },
    valk_artist = "Scraptake",

    loc_vars = function(self, info_queue, card)

        -- for i,deck in pairs(decks) do
        --     local first = i:match("^(%w+)") -- i was told to do this by someone else
        --     first = first and first:lower() or ""
        --     info_queue[#info_queue + 1] = {set = "Other", key = first}
        -- end


        


        if G and G.GAME and G.GAME.selected_back and G.GAME.selected_back.name then
            local first = G.GAME.selected_back.name
            if not string.find(first, "cry") then
                first = first:match("^(%w+)")
            end
            first = first and first:lower() or ""
            first = first:gsub("-", "") --remove hyphen from name
            -- print(first)
            info_queue[#info_queue + 1] = {set = "Other", key = first}
            return {vars = {"applicable", ""}}
        else
            return {vars = {"", "not applicable"}}
        end


    end,

    in_pool = function()
        local deckname = G.GAME.selected_back.name
        if decks[deckname] then
            return true
        end
        return false
    end,

    redeem = function(self, card)
        local deckname = G.GAME.selected_back.name
        if decks[deckname] then
            decks[deckname](true, nil)
        end
    end,

    calculate = function(self, card, context)
        local deckname = G.GAME.selected_back.name
        if decks[deckname] then
            decks[deckname](false, context)
        end

        
        
         
    end

    


}

SMODS.Voucher {
    key = "legendary_perkup",
    atlas = "main",
    pos = {x=14, y=5},
    loc_txt = {
        name = "Legendary PERK-UP!",
        text = {
            "{C:attention}Jokers{} have a {C:green}5%{} chance to be replaced by",
            "a {C:legendary}Legendary{} Joker when created",
        }
    },
    valk_artist = "Pangaea",
    cost = 20,

    loc_vars = function(self, info_queue, card)
        
    end,

    in_pool = function()
        return (G.GAME.round_resets.ante >= 4)
    end,

    redeem = function(self, card)
        G.GAME.legendary_replace = 5
    end,
}

SMODS.Voucher {
    key = "exquisite_perkup",
    atlas = "main",
    pos = {x=14, y=6},
    loc_txt = {
        name = "Exquisite PERK-UP!",
        text = {
            "{C:attention}Jokers{} have a {C:green}2%{} chance to be replaced by",
            "an {C:valk_exquisite}Exquisite{} Joker when created",
        }
    },
    valk_artist = "Pangaea",
    cost = 20,

    loc_vars = function(self, info_queue, card)
        
    end,

    redeem = function(self, card)
        G.GAME.exotic_replace = 2
    end,
    requires = {"v_valk_legendary_perkup"},
}

SMODS.Voucher {
    key = "prestige_up",
    atlas = "main",
    pos = {x=14, y=7},
    loc_txt = {
        name = "PRESTIGE-UP!",
        text = {
            "{C:attention}Jokers{} have a {C:green}1%{} chance to be replaced by",
            "a {C:valk_prestigious}Prestigious{} Joker when created",
        }
    },
    valk_artist = "Pangaea",
    cost = 20,

    loc_vars = function(self, info_queue, card)
        
    end,

    redeem = function(self, card)
        G.GAME.prestigious_replace = 1
    end,
    requires = {"v_valk_exquisite_perkup"},
}

SMODS.Voucher {
    key = "reptilian",
    atlas = "atlas2",
    pos = {x=5, y=2},
    loc_txt = {
        name = "Reptilian",
        text = {
            "Always draw {C:attention}#1#{} more card when drawing cards",
        }
    },
    valk_artist = "mailingway",
    cost = 10,
    config = {extra = {cards = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = { card.ability.extra.cards }}
    end,

    redeem = function(self, card)
        G.GAME.bonus_draw = G.GAME.bonus_draw and (G.GAME.bonus_draw + card.ability.extra.cards) or card.ability.extra.cards 
    end,
}

SMODS.Voucher {
    key = "reptoid",
    atlas = "atlas2",
    pos = {x=6, y=2},
    loc_txt = {
        name = "Reptoid",
        text = {
            "Always draw at least {C:attention}#1#{} cards, even if you",
            "wouldn't have drawn cards",
        }
    },
    valk_artist = "mailingway",
    cost = 10,
    config = {extra = {cards = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = { card.ability.extra.cards }}
    end,

    redeem = function(self, card)
        G.GAME.force_bonus_draw = G.GAME.force_bonus_draw and (G.GAME.force_bonus_draw + card.ability.extra.cards) or card.ability.extra.cards 
    end,
    requires = {"v_valk_reptillian"}
}

