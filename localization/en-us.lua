return {
    descriptions = {
        Other = {
            red = {
                name = "Red Deck",
                text = {
                    "{C:attention}+2{} discard limit"
                }
            },
            blue = {
                name = "Blue Deck",
                text = {
                    "{C:attention}+2{} play limit"
                }
            },
            yellow = {
                name = "Yellow Deck",
                text = {
                    "Earn {C:money}+$2{} at end of round"
                }
            },
            green = {
                name = "Green Deck",
                text = {
                    "Discards are worth {C:money}+$1{} when cashing out"
                }
            },
            black = {
                name = "Black Deck",
                text = {
                    "Refund {C:attention}0.5{} {C:blue}hands{} if played hand",
                    "is {C:attention}most played hand{}"
                }
            },
            magic = {
                name = "Magic Deck",
                text = {
                    "Create a {C:spectral}Spectral{} or {C:tarot}Tarot card at",
                    "end of round",
                }
            },
            nebula = {
                name = "Nebula Deck",
                text = {
                    "At end of round, apply the effects of all {C:attention}owned{} {C:planet}planet{} cards",
                    "{C:inactive}(Does not consume planet card){}"
                }
            },
            ghost = {
                name = "Ghost Deck",
                text = {
                    "Selling a {C:spectral}Spectral{} card will reroll it into another spectral card",
                    "{C:inactive}(Can only be used once per card){}"
                }
            },
            abandoned = {
                name = "Abandoned Deck",
                text = {
                    "Scored {C:clubs}clubs{} are converted into {C:spades}spades{}",
                    "and {C:diamonds}diamonds{} are converted into {C:hearts}hearts{}"
                }
            },
            checkered = {
                name = "Checkered Deck",
                text = {
                    "Scored {C:spades}spades{} are converted into {C:attention}4{}s",
                    "and {C:hearts}hearts{} are converted into {C:attention}7{}s"
                }
            },
            zodiac = {
                name = "Zodiac Deck",
                text = {
                    "Multiply the {C:chips}Chips{} and {C:mult}Mult{} per-level of each",
                    "hand by {C:attention}3{}"
                }
            },
            painted = {
                name = "Painted Deck",
                text = {
                    "{C:attention}+1{} Hand Size when a {C:common}non-common{} Joker is sold"
                }
            },
            anaglyph = {
                name = "Anaglyph Deck",
                text = {
                    "Create a {C:attention}Double Tag{} when blind selected"
                }
            },
            plasma = {
                name = "Plasma Deck",
                text = {
                    "Earn {C:money}+$1{} from all sources",
                    "{C:inactive}(Includes losing money){}"
                }
            },
            erratic = {
                name = "Erratic Deck",
                text = {
                    "Scored cards are converted into a {C:attention}random card{}",
                    "in hand"
                }
            },
            cryantimatter = {
                name = "Antimatter Deck",
                text = {
                    "Applies all {C:attention}Quantum Particle{} effects"
                }
            },
            cata_self_banish = {
                name = "Cataclysm Card",
                text = {
                    "This card will {C:red}Banish{}",
                    "itself when used"
                }
            },

        },
        Sleeve = {
            sleeve_valk_s_handbuffdeck = {
                name = "Buffed Sleeve",
                text = {
                    "All {C:attention}Hand Modifiers{} can be made with {C:attention}#1#{} cards",
                    "{C:attention}#2#{} Hand Size",
                }
            },
            sleeve_valk_s_handbuffdeck_alt = {
                name = "Buffed Sleeve",
                text = {
                    "All {C:attention}Hand Modifiers{} can be made with {C:attention}#3#{} card",
                    "{C:attention}#2#{} Hand Size",
                }
            }
        }


    },
    misc = {
        v_text = {
            ch_c_valk_chips_expo = {
                "{X:dark_edition,C:white}^0.6{} All Chip effects"
            },
            ch_c_valk_mult_expo = {
                "{X:dark_edition,C:white}^0.6{} All Mult effects"
            },

            ch_c_valk_chips_expo_weak = {
                "{X:dark_edition,C:white}^0.85{} All Chip effects"
            },
            ch_c_valk_mult_expo_weak = {
                "{X:dark_edition,C:white}^0.85{} All Mult effects"
            },

            ch_c_valk_chips_expo_positive = {
                "{X:dark_edition,C:white}^1.15{} All Chip effects"
            },
            ch_c_valk_mult_expo_positive = {
                "{X:dark_edition,C:white}^1.2{} All Mult effects"
            },

            ch_c_valk_money_expo = {
                "{X:dark_edition,C:white}^0.9{} Money Gain"
            },
            ch_c_valk_shop_sucks = {
                "The shop sells {C:red,E:1,s:1.2}nothing{}"
            },
            ch_c_valk_tag_end_round = {
                "At end of round, create a {C:attention}Charm Tag{}, {C:attention}Meteor Tag{},"
            },
            ch_c_valk_tag_end_ante = {
                "Create an extra tag at end of ante"
            },

            ch_c_valk_shop_sucks_booster = {
                "The shop {C:red,E:1}does not{} sell Booster Packs"
            },
            
            ch_c_valk_tag_end_round2 = {
                "{C:attention}Buffoon Tag{}, or {C:attention}Standard Tag{}"
            },

            ch_c_valk_random_tags = {
                "At end of round, create {C:attention}3 random Tags{}"
            },

            ch_c_valk_start_late = {
                "Start {C:attention}3{} antes later"
            },

            ch_c_valk_free_money = {
                "Start with an extra {C:money}$50{}"
            },

            ch_c_valk_start_in_shop = {
                "Begin the run in the shop"
            },

            ch_c_valk_all_previous = {
                "Applies {C:red}All previous{} challenges (see below)"
            },

            ch_c_valk_all_previous2 = {
                "{C:inactive}(Does not apply C5 starting Ante){}"
            },
        },
        dictionary = {
            ph_valk_beavers = "The beavers ravage the blind.",
        },
        v_dictionary = {
            a_valk_eechips = "^^#1# Chips",
            a_valk_eemult = "^^#1# Mult",
        },

    }
}
