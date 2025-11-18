
SMODS.Joker {
    bases = {"j_rocket"},
    key = "tau_rocket",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Rocket{}",
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "Multiply dollars earned by {X:money,C:white}$X#2#{} when {C:attention}Boss Blind{} defeated",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { cur = 2, mult = 2} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cur, card.ability.extra.mult}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=3, y=1},
    cost = 4,
    no_doe = true,

    calc_dollar_bonus = function(self, card)
		return card.ability.extra.cur
	end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss then

            card.ability.extra.cur = card.ability.extra.cur * card.ability.extra.mult

        end

    end
}

SMODS.Joker {
    bases = {"j_loyalty_card"},
    key = "tau_loyalty",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Loyalty Card{}",
        text = {
            "{C:attention}Triple{} this Jokers {{X:mult,C:white}XMult{} every {C:attention}#1#{} {C:inactive}[#2#]{} hands played",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { xmult = 1}, immutable = { hands = 6, req = 6 } },
    loc_vars = function(self, info_queue, card)

        return { vars = { card.ability.immutable.req, card.ability.immutable.hands, card.ability.extra.xmult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=2},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.before and not context.blueprint then

            card.ability.immutable.hands = card.ability.immutable.hands - 1
            if card.ability.immutable.hands < 1 then
                card.ability.immutable.hands = card.ability.immutable.req
                card.ability.extra.xmult = to_big(card.ability.extra.xmult)*2
                -- self misprintizing! how could this ever go wrong!
            end

        end

        if context.joker_main then
            return {xmult = card.ability.extra.xmult}
        end

    end
}

SMODS.Joker {
    bases = {"j_marble"},
    key = "tau_marble",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Marble Joker{}",
        text = {
            "First scoring card is converted into a {C:attention}Stone{} card",
            "{C:attention}Stone{} cards give {X:chips,C:white}X#1#{} Chips when scored",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { xchip = 1.42 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.xchip } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=3, y=0},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.after then

            if context.scoring_hand and context.scoring_hand[1] then
                local first = context.scoring_hand[1]
                G.E_MANAGER:add_event(Event({
                    func = function()
                        first:set_ability("m_stone")
                        first:juice_up()
                    end,
                }))
                
            end

        end

        if context.individual and context.cardarea == G.play then
            local en = SMODS.get_enhancements(context.other_card)
            if en and en.m_stone then
                return {xchips = card.ability.extra.xchip}
            end

        end

    end
}


SMODS.Joker {
    bases = {"j_stencil"},
    key = "tau_stencil",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Joker Stencil{}",
        text = {
            "{C:attention}+#1#{} Joker Slots",
            "At end of round, gains {C:attention}+#2#{} Joker Slot",
            "if no other Jokers are owned",
            "Gives {X:mult,C:white}Xmult{} equal to total Joker slots",
            
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { slots = 2, gain = 1 }, immutable = {cap = 1e100} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=5},
    cost = 4,
    no_doe = true,

    add_to_deck = function(self ,card, from_debuff)
        G.jokers:change_size(card.ability.extra.slots)
    end,

    calculate = function(self, card, context)
        
        if context.end_of_round and G.jokers.config.card_count == 1 then
            G.jokers:change_size(card.ability.extra.gain)
            card.ability.extra.slots = card.ability.extra.slots + card.ability.extra.gain
        end

        if context.joker_main then
            return {xmult = G.jokers.config.card_limit}
        end

    end
}

SMODS.Joker {
    bases = {"j_four_fingers"},
    key = "tau_fingers",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Four Fingers{}",
        text = {
            "{C:attention}Flushes{} and {C:attention}Straights{} can be made with {C:attention}3{} cards", --booo hardcoding. whatever. go complain to smods. --i will! not! . its fine here
            "Level up all hands by {C:attention}#1#{} when consumable used",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { levels = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.levels } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=6},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.using_consumeable then

            level_all_hands(context.consumeable, card.ability.extra.levels)
            card.ability.extra.levels = card.ability.extra.levels + card.ability.extra.inc
            
        end

    end
}

SMODS.Joker {
    bases = {"j_ceremonial"},
    key = "tau_dagger",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Ceremonial Dagger{}",
        text = {
            "When {C:attention}blind{} selected, {C:red,E:1}destroy{} Joker to the right and",
            "add {C:attention}one tenth{} of its sell value to this Jokers {X:dark_edition,C:white}^Mult{}",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#1#{C:inactive} Mult)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=5},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.setting_blind then

            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                    local sliced_card = G.jokers.cards[my_pos+1]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        card.ability.extra.mult = card.ability.extra.mult + (sliced_card.sell_cost/10)
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.mult+sliced_card.sell_cost}}, colour = G.C.RED, no_juice = true})
                    return nil, true
                end

        end

        if context.joker_main then
            return {emult = card.ability.extra.mult}
        end

    end
}

SMODS.Joker {
    bases = {"j_troubadour"},
    key = "tau_troubadour",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Troubadour{}",
        text = {
            "{C:attention}+#1#{} hand size when card scored",
            "Convert every {C:attention}#3#{} Hand Size beyond {C:attention}#2#{} to {C:attention}#1#{} Consumable Slot",
            "Convert every {C:attention}#3#{} Consumable slots beyond {C:attention}#2#{} to {C:attention}#1#{} Joker Slot",
            "Convert every {C:attention}#3#{} Joker Slots beyond {C:attention}#2#{} to {C:attention}#1#{} Shop Slot",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { max = 10, gain = 1, ratio = 5} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.max, card.ability.extra.ratio } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=9, y=1},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.individual and context.cardarea == G.play then

            G.hand:change_size(card.ability.extra.gain)
            -- change_shop_size(center_table.extra)

            -- oops? why the FUCK
            if G.hand.config.card_limit > (card.ability.extra.max + card.ability.extra.ratio) then
                G.hand:change_size(-card.ability.extra.ratio)
                G.consumeables:change_size(card.ability.extra.gain)
            end

            if G.consumeables.config.card_limit > (card.ability.extra.max + card.ability.extra.ratio) then
                G.consumeables:change_size(-card.ability.extra.ratio)
                G.jokers:change_size(card.ability.extra.gain)
            end

            if G.jokers.config.card_limit > (card.ability.extra.max + card.ability.extra.ratio) then
                G.jokers:change_size(-card.ability.extra.ratio)
                change_shop_size(card.ability.extra.gain)
            end

        end

    end
}


SMODS.Joker {
    bases = {"j_oops"},
    key = "tau_oops",
    loc_txt = {
        name = "{C:valk_tauic}Oops! All six point two eights!{}",
        text = {
            "Multiplies all {C:attention}listed{} {C:green}probabilities{} by {C:attention}Tau{}",
            "{C:green}#1# in #2#{} chance to earn {C:dark_edition}+#3#{} Joker slot and {C:money}$#4#{} when {C:attention}consumable{} used",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { base = 1, chance = 62.831853, slots = 1, money = 8 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = "tau_number" }
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.base, card.ability.extra.chance, 'oa6.28')
        return {vars = {num, den, card.ability.extra.slots, card.ability.extra.money}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=8, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if context.mod_probability then
            return {numerator = context.numerator * 6.2831853}
        end

        if (context.using_consumeable) and SMODS.pseudorandom_probability(card, 'valk_oa6', card.ability.extra.base, card.ability.extra.chance, 'oa6.28') then

            G.jokers:change_size(card.ability.extra.slots)
            ease_dollars(card.ability.extra.money)

        end

        

        -- select(2,next(G.consumeables.cards))

    end,

}

--CONTINUE FROM HERE

SMODS.Joker {
    bases = {"j_satellite"},
    key = "tau_satellite",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Satellite{}",
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "Increases by {C:money}$#2#{} when planet card used",
            "Scales {C:dark_edition,E:1}Quadratically{}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { cur = 1, inc = 1, incsq = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cur, card.ability.extra.inc, card.ability.extra.incsq}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.using_consumeable) then

            if (context.consumeable.ability.set == "Planet") then 
            
                card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.inc
                card.ability.extra.inc = card.ability.extra.inc + card.ability.extra.incsq

            end

        end

        -- select(2,next(G.consumeables.cards))

    end,

    calc_dollar_bonus = function(self, card)
		return card.ability.extra.cur
	end,


}

SMODS.Joker {
    bases = {"j_cartomancer"},
    key = "tau_cartomancer",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Cartomancer{}",
        text = {
            "{C:green}#1# in #2#{} chance to create a {C:dark_edition}Negative{} {C:tarot}Tarot{} card",
            "when a {C:attention}Consumable{} is used",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { min = 1, prob = 3 } },
    loc_vars = function(self, info_queue, card)
        local num,den = SMODS.get_probability_vars(card, card.ability.extra.min, card.ability.extra.prob)
        return {vars = {num,den}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.using_consumeable and SMODS.pseudorandom_probability(card, "valk_tau_carto", card.ability.extra.min, card.ability.extra.prob) ) then
            SMODS.add_card({set = "Tarot", area = G.consumeables, edition = "e_negative"})
        end

    end
}

SMODS.Joker {
    bases = {"j_mime"},
    key = "tau_mime",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Mime{}",
        text = {
            "Retrigger all playing cards {C:attention}#1#{} times",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { triggers = 3 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.triggers}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

		if context.repetition and context.cardarea == G.play or (context.cardarea == G.hand and context.card_effects and (next(context.card_effects[1]) or #context.card_effects > 1)) then
            -- print("p.card")
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.extra.triggers,
				card = card,
			}
		end

    end
}

SMODS.Joker {
    bases = {"j_steel_joker"},
    key = "tau_steel_joker",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Steel Joker{}",
        text = {
            "{X:dark_edition,C:white}+^#1#{} Mult for each {C:attention}Steel card{} in deck",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gain = 0.15 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel


        return {vars = {card.ability.extra.gain, 1+(card.ability.extra.gain*enhanced_in_deck("m_steel"))}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=3},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)

		if context.joker_main then
            return {
                emult = 1+(card.ability.extra.gain*enhanced_in_deck("m_steel"))
            }
        end

    end
}

SMODS.Joker {
    bases = {"j_dusk"},
    key = "tau_dusk",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Dusk{}",
        text = {
            "{C:attention}Retrigger{} each played card {C:attention}once{}",
            "for each hand played this round",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=7},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)

		if context.repetition and context.cardarea == G.play then
            -- print("p.card")
			return {
				message = localize("k_again_ex"),
				repetitions = G.GAME.round_resets.hands - G.GAME.current_round.hands_left,
				card = card,
			}
		end

    end
}

local function fib(n)
    n = to_big(n)
    local Phi = 1.6180399
    local phi = Phi - 1
    local fibn = ((Phi^n) - (-phi^n)) / math.sqrt(5) 
    return fibn
end

SMODS.Joker {
    bases = {"j_fibonacci"},
    key = "tau_fibonacci",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Fibonacci{}",
        text = {
            "Playing cards give {C:mult}Mult{} equal to the {C:attention}Nth Fibonacci number{}",
            "Increase N by {C:attention}#1#{} at end of round",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { n = 1, gain = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.gain, fib(card.ability.extra.n)
        }}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=5},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)

		if context.individual and context.cardarea == G.play then
            return {
                mult = fib(card.ability.extra.n)
            }
        end

        if context.end_of_round and context.main_eval then
            card.ability.extra.n = card.ability.extra.n + card.ability.extra.gain
            quick_card_speak(card, localize("k_upgrade_ex"))
        end

    end
}