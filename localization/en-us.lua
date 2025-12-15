return {
    descriptions = {
        Joker = {
            j_valk2_homely_joker = {
                name = "Homely Joker",
                text = {
                    "{C:red}+#1#{} Mult if played hand",
                    "contains a {C:attention}Full Mansion{}"
                }
            },
            j_valk2_roomy_joker = {
                name = "Roomy Joker",
                text = {
                    "{C:blue}+#1#{} Chips if played hand",
                    "contains a {C:attention}Full Mansion{}"
                }
            },
            j_valk2_the_home = {
                name = "The Home",
                text = {
                    "{X:red,C:white}X#1#{} Mult if played hand",
                    "contains a {C:attention}Full Mansion{}"
                }
            },
            j_valk2_suckit = {
                name = "{C:red}Suck It{}",
                text = {
                    "Creates itself when removed",
                    "{C:green}#1# in #2#{} chance to not come back,",
                    "and give {C:money}$#3#{}",
                }
            },
            j_valk2_antithesis = {
                name = "Antithesis",
                text = {
                    "Unscored cards each",
                    "give {C:mult}+#1#{} Mult"
                }
            },
            j_valk2_kitty = {
                name = "Kitty",
                text = {
                    "At end of round, {C:green}#1# in #2#{} chance",
                    "to create a {C:attention}Kitty Tag{}",
                }
            },
            j_valk2_fancy_joker = {
                name = "Fancy Joker",
                text = {
                    "{C:mult}+#1#{} Mult for every ",
                    "{C:attention}Enhanced{} card {C:attention}held-in-hand{}",
                }
            },
            j_valk2_posh_joker = {
                name = "Posh Joker",
                text = {
                    "{C:chips}+#1#{} Chips for every ",
                    "{C:attention}Enhanced{} card {C:attention}held-in-hand{}",
                }
            },
            j_valk2_whereclick = {
                name = "{C:red}Where do I click?{}",
                text = {
                    "Gains {X:mult,C:white}X#1#{} Mult when a card is sold",
                    "Loses {X:mult,C:white}X#2#{} Mult when a {C:attention}Consumable{} is used",
                    "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult){}",
                    "{C:inactive}Where do I click, Drago?{}",
                }
            },
            j_valk2_streetlight = {
                name = "Streetlight",
                text = {
                    "Gains {X:mult,C:white}X#1#{} Mult when an",
                    "{C:attention}Enhanced{} card scores",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
                }
            },
            j_valk2_periapt_beer = {
                name = "Periapt Beer",
                text = {
                    "Create a {C:tarot}Charm Tag{}",
                    "and {C:attention}The Fool{} when sold"
                }
            },
            j_valk2_stellar_yogurt = {
                name = "Stellar Yogurt",
                text = {
                    "Create a {C:planet}Meteor Tag{}",
                    "and {C:attention}The Fool{} when sold"
                }
            },
            j_valk2_hexed_spirit = {
                name = "Hexed Spirit",
                text = {
                    "Create two {C:spectral}Ethereal Tags{}",
                    "when sold"
                }
            },
            j_valk2_amber = {
                name = "Amber",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for",
                    "each scoring {C:diamonds}Diamond{}"
                }
            },
            j_valk2_blackjack = {
                name = "Blackjack",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for",
                    "each scoring {C:spades}Spade{}"
                }
            },
            j_valk2_troupe = {
                name = "Troupe",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for",
                    "each scoring {C:spades}Club{}"
                }
            },
            j_valk2_valentine = {
                name = "Valentine",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for",
                    "each scoring {C:hearts}Heart{}"
                }
            },
            j_valk2_rocky = {
                name = "Rocky",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for",
                    "each scoring {C:attention}Suitless{} card"
                }
            }
        },
        Tag = {
            tag_valk2_kitty = {
                name = "Kitty Tag",
                text = {
                    "Gives {C:chips}+#1#{} Chips for every",
                    "{C:attention}Kitty Tag{} owned",
                    VALK.UTILS.credit("Scraptake", "artist")
                }
            },
            tag_valk2_negativeeternal = {
               name = "Negative Eternal Tag",
                text = {
                    "Next base edition shop Joker",
                    "will be {C:attention}free, {C:dark_edition}Negative{}",
                    "and {C:purple}eternal{}",
                    VALK.UTILS.credit("Pangaea", "artist")
                } 
            }
        },
        Voucher = {
            v_valk2_alpha_boosterator = {
                name = "Alpha XP Boosterator",
                text = {
                    "{X:dark_edition,C:white}X#1#{} to all XP gain",
                    "{C:inactive}(XP Boosterators apply in the order they were obtained)",
                }
            },
            v_valk2_beta_boosterator = {
                name = "Beta XP Boosterator",
                text = {
                    "{X:dark_edition,C:white}^#1#{} to all XP gain",
                    "{C:inactive}(XP Boosterators apply in the order they were obtained)",
                }
            },
            v_valk2_gamma_boosterator = {
                name = "Gamma XP Boosterator",
                text = {
                    "{X:dark_edition,C:white}^#1#{} to all XP gain",
                    "{C:inactive}(XP Boosterators apply in the order they were obtained)",
                }
            },
        }
    },
    misc = {
        poker_hands = {
			valk2_full_mansion = "Full Mansion"
		},
		poker_hand_descriptions = {
			valk2_full_mansion = {
				"3 of a kind and 4 of a kind"
			}
		},
        dictionary = {
            k_cat_by = "Cat By",
            k_art_by = "Art By",
            k_shader_by = "Shader By",

            k_plus_kitty_tag = "+1 Kitty Tag"
        }
    }
}