SMODS.Joker {
    bases = {"j_joker"},
    key = "tau_joker",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Joker{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult for every {C:valk_tauic}Tauic{} Joker owned",
            "{C:inactive}(Includes self){}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { mult = 1.4444} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=1},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if (context.other_joker and context.other_joker.config.center.rarity == "valk_tauic") then
            return {xmult = card.ability.extra.mult}
        end
    end
}

SMODS.Joker {
    bases = {"j_chaos"},
    key = "tau_clown",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Chaos the Clown{}",
        text = {
            "{C:attention}#1#{} free {C:green}rerolls{} in shop",
            "When blind selected, gain {C:attention}#2#{} {C:blue}hand{} and {C:red}discard{} per {C:green}reroll{} in last shop",
            "{C:inactive}(Currently {C:attention}+#3#{} {C:blue}Hands{C:inactive} and {C:red}Discards{C:inactive})",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { rerolls = 2, bonus = 1, current = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rerolls, card.ability.extra.bonus, card.ability.extra.current } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=1},
    cost = 4,
    no_doe = true,

    add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.rerolls)
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(-card.ability.extra.rerolls)
    end,

    calculate = function(self, card, context)
        if (context.setting_blind) then

            ease_hands_played(card.ability.extra.bonus * card.ability.extra.current)
            ease_discard(card.ability.extra.bonus * card.ability.extra.current)
            card.ability.extra.current = 0
        end

        if (context.reroll_shop) then
            card.ability.extra.current = card.ability.extra.current + 1
        end
    end
}

SMODS.Joker {
    bases = {"j_lusty_joker", "j_greedy_joker", "j_wrathful_joker", "j_gluttenous_joker"},
    key = "tau_sins",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Sin Joker{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult when a card is scored",
            "Increase by {X:mult,C:white}X#2#{} for every consecutive card of the same Suit scored",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult, gaining on {V:1}#4#{C:inactive})",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { base = 1, cur = 1, gain = 0.1, current_suit = "Spades"} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.base, card.ability.extra.gain, card.ability.extra.cur, card.ability.extra.current_suit, colours = {
            G.C.SUITS[card.ability.extra.current_suit]
        } } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=1},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            if context.other_card:is_suit(card.ability.extra.current_suit) then
                card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
                quick_card_speak(card, localize("k_upgrade_ex"))
            else
                card.ability.extra.cur = card.ability.extra.base
                card.ability.extra.current_suit = context.other_card.base.suit
                quick_card_speak(card, localize("k_reset_ex"))
            end

            return {
                xmult = card.ability.extra.cur
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_blue_joker"},
    key = "tau_blue",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Blue Joker{}",
        text = {
            "{X:chips,C:white}X#1#{} Chips for each",
            "remaining card in {C:attention}deck{}",
            "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { per = 1 } },
    loc_vars = function(self, info_queue, card)
        local n = 52
        if G.deck then
            n = #G.deck.cards
        end
        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.per * n
            }
        }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=10},
    cost = 6,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.joker_main then
            return {
                xchips = card.ability.extra.per * #G.deck.cards
            }
        end

    end
}

SMODS.Joker {
    bases = {"j_even_steven", "j_odd_todd"},
    key = "tau_brothers",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Number Brothers{}",
        text = {
            "Scored {C:attention}odd-numbered{} ranks give {X:chips,C:white}X#1#{} Chips",
            "Scored {C:attention}even-numbered{} ranks give {X:mult,C:white}X#1#{} Mult",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { mul = 2 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mul}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=8, y=4},
    cost = 6,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.individual and context.cardarea == G.play then
            return {
                xmult = (context.other_card:get_id() % 2) == 0 and card.ability.extra.mul,
                xchips = ((context.other_card:get_id() + 1) % 2) == 0 and card.ability.extra.mul,
            }
        end

    end
}

SMODS.Joker {
    bases = {"j_egg"},
    key = "tau_egg",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Egg{}",
        text = {
            "Gains {C:money}$#1#{} of Sell Value at end of round",
            "{C:green}#2# in #3#{} Chance to come back after being removed",
            "{C:attention}Doubles{} Sell Value gain at end of round",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gain = 3, num = 3, den = 5 } },
    loc_vars = function(self, info_queue, card)
        local num,den = SMODS.get_probability_vars(card, to_number(card.ability.extra.num), to_number(card.ability.extra.den))
        return { vars = { card.ability.extra.gain, num, den } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=10},
    cost = 6,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.end_of_round and context.main_eval then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.gain
            card.ability.extra.gain = card.ability.extra.gain * 2
            card:set_cost()
            return {
                message = localize("k_val_up"),
                colour = G.C.MONEY
            }
        end

    end,
    remove_from_deck = function(self, card, from_debuff)
        if (not from_debuff) and SMODS.pseudorandom_probability(card, "valk_tau_egg", to_number(card.ability.extra.num), to_number(card.ability.extra.den)) then
            SMODS.add_card({key = "j_valk_tau_egg"})
        end 
    end
}

SMODS.Joker {
    bases = {"j_mystic_summit"},
    key = "tau_summit",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Summit{}",
        text = {
            "{C:attention}Double{} Mult of played hand",
            "if all {C:red}Discards{} have been used",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)

        return { vars = {  } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=0},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.after and G.GAME.current_round.discards_left <= 0 then
            vallkarri.simple_hand_text(context.scoring_name)
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { mult = "X2" })
            if G.GAME.hands[context.scoring_name] then
                G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult * 2
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
                end
            }))
        end

    end
}

SMODS.Joker {
    bases = {"j_banner"},
    key = "tau_banner",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Banner{}",
        text = {
            "{X:chips,C:white}X#1#{} Chips per discard remaining",
            "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { per = 3 } },
    loc_vars = function(self, info_queue, card)
        local d = 4
        if G and G.GAME and G.GAME.current_round then
            d = G.GAME.current_round.discards_left
        end
        return { vars = { card.ability.extra.per, 1 + (card.ability.extra.per * d) } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=8, y=2},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.joker_main then

            return {xchips = 1 + (card.ability.extra.per * G.GAME.current_round.discards_left)}

        end

    end
}

SMODS.Joker {
    bases = {"j_credit_card"},
    key = "tau_creditcard",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Credit Card{}",
        text = {
            "Refund {C:attention}#1#%{} of all money lost",
        }
    },
    valk_artist = "Lily Felli",
    config = { extra = {refund = 50} }, --value is pointless, it's always a 3/4 refund//not anymore!
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.refund } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=9, y=0},
    cost = 4,
    no_doe = true,
    immutable = true, --fuck you
    calculate = function(self, card, context)
        if context.money_altered and to_big(context.amount) < to_big(0) then
            ease_dollars(context.amount * -(card.ability.extra.refund / 100))
        end
    end
}

SMODS.Joker {
    bases = {"j_jolly", "j_zany", "j_mad", "j_crazy" ,"j_droll",
            "j_sly", "j_wily", "j_clever", "j_devious", "j_crafty"},
    key = "tau_emotion",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Emotional Joker{}",
        text = {
            "{X:chips,C:white}X#1#{} Chips and {X:mult,C:white}X#1#{} Mult",
            "per {C:attention}poker hand{} contained in played hand",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gain = 2} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=0},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        
        if (context.poker_hands) then
            local count = 0
            
            for i,hand in pairs(context.poker_hands) do
                
                if (hand and next(hand) ~= nil) then
                    -- print(hand)
                    count = count + 1
                end
            end


            if (context.joker_main) then
                for i=1,count do
                    SMODS.calculate_effect({xmult = card.ability.extra.gain, xchips = card.ability.extra.gain}, card)
                end
            end
        end

    end
}

SMODS.Joker {
    bases = {"j_half"},
    key = "tau_half",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Half Joker{}",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:attention}Doubles{} when you play {C:attention}#2#{} or less cards ",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { mult = 20, req = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.req } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=2},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand then

            if #context.scoring_hand <= card.ability.extra.req then
                card.ability.extra.mult = card.ability.extra.mult * 2
                quick_card_speak(card, localize("k_upgrade_ex"))
            end

        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }   
        end
    end
}

SMODS.Joker {
    bases = {"j_8_ball"},
    key = "tau_8_ball",
    loc_txt = {
        name = "{C:valk_tauic}Tauic 8 Ball{}",
        text = {
            "When an {C:attention}8{} is scored, create a random {C:tarot}Tarot{} card",
            "with {C:attention}Octuple{} values",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { vmult = 8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.vmult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=5},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 and G.consumeables.config.card_count < G.consumeables.config.card_limit then
            local tarot = SMODS.add_card({set = "Tarot"})
            Cryptid.manipulate(tarot, {value = card.ability.extra.vmult})
        end
    end
}

SMODS.Joker {
    bases = {"j_smiley"},
    key = "tau_smiley",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Smiley Face{}",
        text = {
            "{C:attention}Non-face{} cards are converted into a random {C:attention}face{} card when {C:attention}scored{}",
            "{C:attention}Face{} cards give {X:mult,C:white}X#1#{} Mult",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=15},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            
            if not context.other_card:is_face() then
                local faces = {"Jack", "King", "Queen"}
                SMODS.change_base(context.other_card, nil, faces[pseudorandom("valk_tau_smiley", 1, #faces)])
            else    
                return {
                    xmult = card.ability.extra.xmult,
                }
            end

        end
    end
}

SMODS.Joker {
    bases = {"j_gros_michel"},
    key = "tau_gros_michel",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Gros Michel{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}#2# in #3#{} chance to convert into {C:valk_tauic}Tauic Cavendish{} at end of round",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { xmult = 15, outof = 15, num = 1 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.outof, 'valk_tgm')
        return { vars = { card.ability.extra.xmult, num, den } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=6},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(card, 'valk_bananar', card.ability.extra.num, card.ability.extra.outof, 'valk_tgm') then
            card:set_ability("j_valk_tau_cavendish")
        end
    end
}

SMODS.Joker {
    bases = {"j_cavendish"},
    key = "tau_cavendish",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Cavendish{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            "{C:green}#2# in #3#{} chance to",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { emult = 3.33, outof = 1000 } },
    loc_vars = function(self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, 1, card.ability.extra.outof)
        return { vars = { card.ability.extra.emult, n,d } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=11},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                emult = card.ability.extra.emult
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_delayed_grat"},
    key = "tau_delayed_grat",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Delayed Gratification{}",
        text = {
            "Gain {C:money}current money{} as discards",
            "Earn {C:money}$#1#{} for every {C:red}#2#{} Discards left at end of round",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { dollar = 1, per = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollar, card.ability.extra.per } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=3},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if context.setting_blind then
            ease_discard(to_number(math.min(G.GAME.dollars, 1e100)))
        end
    end,
    calc_dollar_bonus = function(self, card)
        return math.floor(G.GAME.current_round.discards_left / card.ability.extra.per)
    end
}

SMODS.Joker {
    bases = {"j_hanging_chad"},
    key = "tau_hanging_chad",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Hanging Chad{}",
        text = {
            "Retrigger the {C:attention}first{} played card {C:attention}once{} for each card played",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=9, y=6},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == G.play.cards[1] then
            return {
                repetitions = #G.play.cards,
                message = localize("k_again_ex"),
				card = card,
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_misprint"},
    key = "tau_misprint",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Misprint{}",
        text = {
            "{X:dark_edition,C:white}#1##2#{}#3#",
        }
    },
    valk_artist = "Scraptake",
    immutable = true,
    config = { extra = {min = 1.01, max = 9.99 } },
    loc_vars = function(self, info_queue, card)
        local text = corrupt_text("^", 0.2)
        local text1 = corrupt_text("xxx", 1, "01234567890123456789012345678901234567890123456789")
        local text2 = corrupt_text(" Mult", 0.2)
        return { vars = { text, text1, text2 } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=3},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local temp = (pseudorandom("valk_tau_misprint") * (card.ability.extra.max - card.ability.extra.min)) + card.ability.extra.min
            return {
                emult = temp
            }
        end
    end,
}


SMODS.Joker {
    bases = {"j_photograph"},
    key = "tau_photograph",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Photograph{}",
        text = {
            "The first scored {C:attention}face{} card gives",
            "{X:dark_edition,C:white}^#1#{} Mult",
        }
    },
    valk_artist = "Scraptake",
    immutable = true,
    config = { extra = { amount = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.amount} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=13},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            local first_face = nil
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
            end
            if context.other_card == first_face then
                return {emult = card.ability.extra.amount}
            end
        end
    end,
}


SMODS.Joker {
    bases = {"j_ice_cream"},
    key = "tau_ice_cream",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Ice Cream{}",
        text = {
            "Gains {X:chips,C:white}X#2#{} per hand played",
            "{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive} Chips)",
        }
    },
    valk_artist = "Scraptake",
    immutable = true,
    config = { extra = {cur = 1, gain = 0.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cur, card.ability.extra.gain} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=10},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.after and context.main_eval then
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            quick_card_speak(card, "Upgraded!")
        end

        if context.joker_main then
            return {
                xchips = card.ability.extra.cur
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_ride_the_bus"},
    key = "tau_ride_the_bus",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Ride the Bus{}",
        text = {
            "{C:attention}Non-face{} cards give",
            "{X:mult,C:white}X#1#{} Mult when scored",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = {powmult = 1.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.powmult} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    blueprint_compat = true,
    pos = {x=0, y=0},
    soul_pos = {x=1, y=6},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            if not context.other_card:is_face() then
                return { xmult = card.ability.extra.powmult }
            end
        end
    end
}

SMODS.Joker {
    bases = {"j_raised_fist"},
    key = "tau_raised_fist",
    loc_txt = {
        name = "{C:valk_tauic}Tauic Raised Fist{}",
        text = {
            "The lowest ranked card {C:attention}held in hand{} gives",
            "{X:dark_edition,C:white}^Mult{} equal to {C:attention}#1#x{} its value",
            "{C:inactive,s:0.8}(Cannot go below {X:dark_edition,C:white,s:0.8}^1{s:0.8,C:inactive} Mult)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { percent = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.percent} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    blueprint_compat = true,
    pos = {x=0, y=0},
    soul_pos = {x=8, y=3},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.hand and not context.end_of_round) then
            -- code taken from original raised fist
            local nominal, card_id = 15, 15
            local raised_card = nil
            for i=1, #G.hand.cards do
                if card_id >= (G.hand.cards[i].base.id or math.huge) and not SMODS.has_no_rank(G.hand.cards[i]) then 
                    nominal = G.hand.cards[i].base.nominal
                    card_id = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if context.other_card == raised_card then
                return {emult = math.max(nominal*card.ability.extra.percent,1)}
            end
        end
    end
}
