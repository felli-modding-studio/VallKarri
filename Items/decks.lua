SMODS.Back {
    key = "encore",
    loc_txt = {
        name = "Encore Deck",
        text = {
            "After hand scores,",
            "all {C:attention}end-of-round{}",
            "effects are triggered",
        }
    },
    valk_artist = "Scraptake",
    pos = {x=7, y=8},
    atlas = "main",
    calculate = function(center, back, context)

        if context.after then
            
            SMODS.calculate_context({end_of_round = true, main_eval = true})

        end

    end
}

SMODS.Back {
    key = "tauic",
    loc_txt = {
        name = "Tauic Deck",
        text = {
            "{C:valk_tauic}Tauic{} Jokers are {C:attention}thrice{} as common",
            "for each {C:valk_tauic}non-Tauic{} Joker owned",
            "{C:attention}+#1#{} Effective Ante when buying",
            "a {C:valk_tauic}Tauic{} Joker",
            -- "{C:attention}X3{} Blind Size",
        }
    },
    valk_artist = "Scraptake",
    config = { eante = 2 },
    pos = {x=7, y=9},
    atlas = "main",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.eante
            }
        }
    end,
    calculate = function(self, back, context)
        if context.valk_tau_probability_mod then

            local count = 0
            for _,joker in pairs(G.jokers.cards) do
                count = count + (joker.config.center.tau and 1 or 0) 
            end

            return {
                denominator = context.denominator / (3 ^ count)
            }
        end

        if context.buying_card and context.card.config.center.is_tau then
            back:juice_up()
            vallkarri.add_effective_ante_mod(self.config.eante, "+")
        end
    end
}

SMODS.Back {
    key = "sunbeam",
    loc_txt = {
        name = "Sunbeam Deck",
        text = {
            "Start with {C:attention,T:v_valk_legendary_perkup}Legendary PERK-UP{},",
            "{C:attention,T:v_valk_exquisite_perkup}Exquisite PERK-UP{}, and ",
            "{C:attention,T:v_valk_prestige_up}PRESTIGE-UP{}",
            "{C:attention}+#1#{} Effective Ante",
            "when buying from shop",
        }
    },
    valk_artist = "Scraptake",
    config = { vouchers = { "v_valk_legendary_perkup", "v_valk_exquisite_perkup", "v_valk_prestige_up" }, eante = 0.2 },
    pos = {x=9, y=8},
    atlas = "main",
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.eante } }
    end,
    calculate = function(self, card, context)
        if context.buying_card then
            -- print("joker obtained")
            vallkarri.add_effective_ante_mod(self.config.eante, "+") --no data to store, no self-destruct condition
        end
    end,
}

SMODS.Back {
    key = "airtight",
    loc_txt = {
        name = "Airtight Deck",
        text = {
            "Give a random {C:attention}Seal{} to",
            "the leftmost card {C:attention}held-in-hand{}",
            "when hand is played",
        }
    },
    valk_artist = nil,
    config = { },
    pos = {x=4, y=0},
    atlas = "phold",
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, back, context)
        if context.after and G.hand.cards[1] then
            G.hand.cards[1]:set_seal(SMODS.poll_seal({key = "valk_airtight_deck", guaranteed = true}))
        end
    end
}

if AKYRS then

    SMODS.Back {
        key = "hyperalphabetical",
        loc_txt = {
            name = "Hyperalphabetical Deck",
            text = {
                "Letters-only deck",
                "{C:attention}+8{} Hand Size",
                "The shop does {C:red}not exist{}",
                "{C:attention}X10{} Blind Size",
                "{C:attention}Infinite{} card selection limit",
                "Spelling a card {C:attention}creates it{}",
                "{C:red}Pointer blacklist{} applies to spelled words",
            }
        },
        valk_artist = "Aikoyori",
        pos = {x=10, y=8},
        atlas = "main",
        calculate = function(center, back, context)

            if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and context.before then
                local word = ""

                for i,pcard in ipairs(G.play.cards) do
                    local letter = pcard.ability.aikoyori_letters_stickers
                    if letter then word = word .. letter end 
                end

                -- print(word)

                for i,cen in pairs(G.P_CENTERS) do
                    local check = localize({type="name_text", set=cen.set, key=cen.key}):gsub(" ", ""):lower()
                    if tostring(word):lower() == check then
                        -- print("succeeded against " .. check)
                        -- print("attempting creation")
                        local ar = area_by_key(cen.key)
                        local blist = Cryptid.pointergetblist and Cryptid.pointergetblist(cen.key) or {}
                        if ar and blist and (not blist[1]) then
                            -- print("cardarea exists")
                            local card = create_card(cen.set, ar, nil, nil, nil, nil, cen.key, "valk_hyperalphabetical")
                            card:add_to_deck()
                            ar:emplace(card)
                        end
                    

                        


                    end
                end
                
            end

        end,
        apply = function(self, back)
            G.GAME.akyrs_always_skip_shops = true
        end,
        dependencies = {"aikoyorisshenanigans"},
        config = {
            akyrs_starting_letters = AKYRS.scrabble_letters,
            starting_deck_size = 100,
            akyrs_selection = 1e100,
            discards = 2,
            akyrs_start_with_no_cards = true,
            akyrs_letters_mult_enabled = true,
            akyrs_hide_normal_hands = true,
            hand_size = 8,
            ante_scaling = 10,
            vouchers = {'v_akyrs_alphabet_soup','v_akyrs_crossing_field'}
        },
    }

end

if vallkarri_config.hand_buffs then
    SMODS.Back {
        key = "handbuffdeck",
        loc_txt = {
            name = "Buffed Deck",
            text = {
                "All {C:attention}Hand Modifiers{} can be made with {C:attention}#1#{} cards",
                "{C:attention}#2#{} Hand Size",
            }
        },
        valk_artist = nil,
        config = { hand_size = -1, requirement = 2 },
        pos = { x = 4, y = 4 },
        atlas = "atlas2",
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.requirement, self.config.hand_size } }
        end,
        apply = function(self, back)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.buff_requirement = self.config.requirement
                    return true
                end
            }))
        end
    }
end