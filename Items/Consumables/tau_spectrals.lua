SMODS.Atlas {
    key = "tauspec",
    px = 71,
    py = 95,
    path = "tauic_spectrals.png"
}

--[[



familiar - destroy ALL cards held in hand, create an enhanced face card for each destroyed card, then give all cards held-in-hand a random edition
grim - destroy ALL cards held in hand, create an enhanced ace for each destroyed card, then give all cards held-in-hand a random seal
incantation - destroy ALL cards held in hand, create an enhanced numbered card for each destroyed card, then *balance* the suit and rank of all cards held in hand
talisman - add a Gold Seal to 3 selected cards in hand, if card already has a Gold Seal, upgrade it to a Gilded Seal
aura - Add a random edition to all selected cards, debuff a random card in deck for every 2 editioned cards
wraith - Create a random renowned Joker, disable money for 1 round
sigil - Convert all cards in deck to a random suit, then randomize the suit of all cards which have the most common suit
ouija - Convert all cards in deck to a random rank, then randomize the rank of all cards which have the most common rank
ectoplasm - Select up to 5 cards, destroy selected cards, then convert hand size to joker slots equal to the amount of cards destroyed
immolate - Select 1 card, destroy all cards in deck that share any properties with this card, earn $2 for each destroyed card
ankh - Select 1 joker, destroy all jokers, then create a new version of the selected joker for each joker destroyed
deja vu - add a Red Seal to 3 selected cards in hand, if card already has a Red Seal, upgrade it to an Entropic Seal
hex - apply Cosmic, R.G.B. or Lordly to a random joker, destroy all other jokers
trance - add a Blue Seal to 3 selected cards in hand, if card already has a Blue Seal, upgrade it to an Galactic Seal
medium - add a Purple Seal to 3 selected cards in hand, if card already has a Purple Seal, upgrade it to a Vibrant Seal
cryptid - create 1 copy of each card held in hand, then randomly destroy half of the cards held in hand
soul - create a random legendary joker from vallkarri

black hole:
Level up all hands once, then double the level of the hand with the lowest level
repeat this until all hands have the same amount of digits as your highest level hand,
multiply all hand levels by the amount of jokers owned, then divide it by the amount of consumables owned
then banish half of all planet cards randomly, x1.5 chips and mult per level on all hands for each planet card banished



related objects:

gilded seal - +$5 when scored, then gives chips equal to money
entropic seal - retrigger once for every card in hand, 1 in 3 chance to self-destruct when triggered, increase denominator by 1 for each safe trigger
galactic seal - when held in hand, level all hands but the played hand, when played, convert 1 level from all other hands to levels for the played hand
vibrant seal - creates a tarot card when discarded, creates a spectral card when played
]]

SMODS.Atlas {
    key = "tspec",
    px = 71,
    py = 95,
    path = "tauic_spectrals.png"
}

SMODS.ConsumableType {
    key = "TauSpec",
    collection_rows = { 4, 5 },
    primary_colour = HEX("CD65D1"),
    secondary_colour = HEX("9477E2"),
    shop_rate = 0,

    loc_txt = {
        collection = "Tauic Spectral Cards",
        label = "tauicspectral",
        name = "Tauic Spectral",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
            }
        }
    },
}

SMODS.Shader {
    key = "inverse_booster",
    path = "inverse_booster.fs"
}

SMODS.DrawStep {
    key = "tauspec_shader",
    order = 11,
    func = function(card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            if card.config.center.set == "TauSpec" then
                card.children.center:draw_shader('valk_inverse_booster', nil, card.ARGS.send_to_shader)
            elseif card.config.center.is_tau then
                card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
            end
        end
    end
}

local spectral_positions = {
    ["c_familiar"] = { x = 0, y = 0 },
    ["c_grim"] = { x = 1, y = 0 },
    ["c_incantation"] = { x = 2, y = 0 },
    ["c_talisman"] = { x = 3, y = 0 },
    ["c_aura"] = { x = 4, y = 0 },
    ["c_wraith"] = { x = 5, y = 0 },
    ["c_sigil"] = { x = 6, y = 0 },
    ["c_ouija"] = { x = 7, y = 0 },
    ["c_ectoplasm"] = { x = 8, y = 0 },
    ["c_immolate"] = { x = 9, y = 0 },
    ["c_ankh"] = { x = 0, y = 1 },
    ["c_deja_vu"] = { x = 1, y = 1 },
    ["c_hex"] = { x = 2, y = 1 },
    ["c_trance"] = { x = 3, y = 1 },
    ["c_medium"] = { x = 4, y = 1 },
    ["c_cryptid"] = { x = 5, y = 1 },
    ["c_black_hole"] = { x = 6, y = 1 },
    ["c_valk_succor"] = { x = 7, y = 1 },
    ["c_valk_luck"] = { x = 8, y = 1 },
    ["c_valk_estrogen"] = { x = 9, y = 1 },
    ["c_valk_testosterone"] = { x = 5, y = 2 },
    ["c_valk_faker"] = { x = 0, y = 2 },
    ["c_valk_absolutetau"] = { x = 1, y = 2 },
    ["c_soul"] = { x = 2, y = 2 },
}

local spectral_soul_positions = {
    ["c_soul"] = { x = 3, y = 2 },
}

local tauspecs = {
    {
        original = "c_familiar",
        can_use = function(self, card)
            return #G.hand.cards > 0
        end,
        use = function(self, card, area, copier)
            local cards = #G.hand.cards
            SMODS.destroy_cards(vallkarri.get_cards(G.hand), false)
            for i = 1, cards do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card({
                            set = "Enhanced",
                            edition = poll_edition("valk_tau_familiar", nil, true, true),
                            rank = vallkarri.poll_face("tau_familiar"),
                            area = G.hand,
                        })
                        return true
                    end,
                    delay = 0.4
                }))
            end
        end,
        desc = {
            "{C:red}Destroy{} all cards {C:attention}held-in-hand{}",
            "Create an {C:attention}Enhanced Editioned Face{} card for",
            "each destroyed card",
        }
    },
    {
        original = "c_grim",
        can_use = function(self, card)
            return #G.hand.cards > 0
        end,
        use = function(self, card, area, copier)
            local cards = #G.hand.cards
            SMODS.destroy_cards(vallkarri.get_cards(G.hand), false)
            for i = 1, cards do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card({
                            set = "Enhanced",
                            edition = poll_edition("valk_tau_grim", nil, true, true),
                            rank = "Ace",
                            area = G.hand,
                        })
                        return true
                    end,
                    delay = 0.4
                }))
            end
        end,
        desc = {
            "{C:red}Destroy{} all cards {C:attention}held-in-hand{}",
            "Create an {C:attention}Enhanced Editioned Ace{} for",
            "each destroyed card",
        }
    },
    {
        original = "c_incantation",
        can_use = function(self, card)
            return #G.hand.cards > 0
        end,
        use = function(self, card, area, copier)
            local cards = #G.hand.cards
            SMODS.destroy_cards(vallkarri.get_cards(G.hand), false)
            for i = 1, cards do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card({
                            set = "Enhanced",
                            edition = poll_edition("valk_tau_incantation", nil, true, true),
                            rank = vallkarri.poll_number("tau_incantation"),
                            area = G.hand,
                        })
                        return true
                    end,
                    delay = 0.4
                }))
            end
        end,
        desc = {
            "{C:red}Destroy{} all cards {C:attention}held-in-hand{}",
            "Create an {C:attention}Enhanced Editioned Numbered{} card for",
            "each destroyed card",
        }
    },
    {
        original = "c_talisman",
        desc = {
            "Add a {C:attention}Gold Seal{} to up to {C:attention}#1#{} selected cards",
            "If only {C:attention}#2#{} card is selected, add a {C:attention}Gilded Seal{} instead",
        },
        config = { extra = { max = 3, min = 1 } },
        can_use = function(self, card)
            return #G.hand.highlighted >= card.ability.extra.min and #G.hand.highlighted <= card.ability.extra.max
        end,
        use = function(self, card, area, copier)
            if #G.hand.highlighted <= card.ability.extra.min then
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("valk_Gilded")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            else
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("Gold")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            end
        end,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS.Gold
            info_queue[#info_queue + 1] = G.P_SEALS.valk_Gilded
            return {
                vars = {
                    card.ability.extra.max, card.ability.extra.min
                }
            }
        end
    },
    {
        original = "c_aura",
        desc = {
            "Add a random {C:attention}Edition{} to",
            "up to {C:attention}#1#{} selected cards",
        },
        config = { extra = { max = 3, min = 1 } },
        can_use = function(self, card)
            return #G.hand.highlighted >= card.ability.extra.min and #G.hand.highlighted <= card.ability.extra.max
        end,
        use = function(self, card, area, copier)
            for _, c in pairs(G.hand.highlighted) do
                c:set_edition(poll_edition("valk_tau_aura", 5, nil, true))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        c.area:remove_from_highlighted(c)
                        return true
                    end,
                    trigger = "after"
                }))
            end
        end,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.max
                }
            }
        end
    },
    {
        original = "c_wraith",
        desc = {
            "Create a random {C:valk_renowned}Renowned{} {C:attention}Joker{}",
            "Lose {C:money}$#1#{} for each {C:attention}Joker{} owned",
            "{C:inactive}(Must have room)",
        },
        config = { extra = { loss = 5 } },
        can_use = function(self, card)
            return (G.jokers.config.card_count + G.GAME.joker_buffer) < G.jokers.config.card_limit
        end,
        use = function(self, card, area, copier)
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({ set = "Joker", rarity = "valk_renowned" })
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    return true
                end,
            }))

            G.E_MANAGER:add_event(Event({
                func = function()
                    for _, joker in pairs(G.jokers.cards) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                joker:juice_up()
                                ease_dollars(-card.ability.extra.loss)
                                return true
                            end,
                            trigger = "after",
                            delay = 0.25,
                        }))
                    end
                    return true
                end
            }))
        end,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.loss
                }
            }
        end
    },
    {
        original = "c_sigil",
        desc = {
            "{C:attention}Randomize{} the Suit of all playing cards in deck, then",
            "{C:attention}re-randomize{} the Suit of all playing cards that are",
            "part of the {C:attention}most populated Suit{}",
        },
        config = { extra = {} },
        can_use = function(self, card)
            return #G.playing_cards > 0
        end,
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _, c in pairs(G.playing_cards) do
                        G.E_MANAGER:add_event(Event({

                            func = function()
                                SMODS.change_base(c, pseudorandom_element(SMODS.Suits, "valk_tau_sigil").key)
                                c:juice_up()

                                return true
                            end

                        }))
                    end

                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({

                func = function()
                    local mps = nil
                    local counts = {}
                    for _, c in pairs(G.playing_cards) do
                        counts[c.base.suit] = counts[c.base.suit] or 0
                        counts[c.base.suit] = counts[c.base.suit] + 1
                    end
                    local biggest = 0
                    for key, count in pairs(counts) do
                        if count > biggest then
                            mps = key
                            biggest = count
                        end
                    end

                    for _, c in pairs(G.playing_cards) do
                        if c:is_suit(mps) then
                            G.E_MANAGER:add_event(Event({

                                func = function()
                                    SMODS.change_base(c,
                                        pseudorandom_element(SMODS.Suits, "valk_tau_sigil_rerandomize").key)
                                    c:juice_up()

                                    return true
                                end

                            }))
                        end
                    end

                    return true
                end

            }))
        end,
    },
    {
        original = "c_ouija",
        desc = {
            "{C:attention}Randomize{} the Rank of all playing cards in deck, then",
            "{C:attention}re-randomize{} the Rank of all playing cards that are",
            "part of the {C:attention}most populated Rank{}",
        },
        config = { extra = {} },
        can_use = function(self, card)
            return #G.playing_cards > 0
        end,
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _, c in pairs(G.playing_cards) do
                        G.E_MANAGER:add_event(Event({

                            func = function()
                                SMODS.change_base(c, nil, pseudorandom_element(SMODS.Ranks, "valk_tau_ouija").key)
                                c:juice_up()

                                return true
                            end

                        }))
                    end

                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({

                func = function()
                    local mpr = nil
                    local counts = {}
                    for _, c in pairs(G.playing_cards) do
                        counts[c.base.value] = counts[c.base.value] or 0
                        counts[c.base.value] = counts[c.base.value] + 1
                    end
                    local biggest = 0
                    for key, count in pairs(counts) do
                        if count > biggest then
                            mpr = key
                            biggest = count
                        end
                    end

                    for _, c in pairs(G.playing_cards) do
                        if c.base.value == mpr then
                            G.E_MANAGER:add_event(Event({

                                func = function()
                                    SMODS.change_base(c, nil,
                                        pseudorandom_element(SMODS.Ranks, "valk_tau_ouija_rerandomize").key)
                                    c:juice_up()

                                    return true
                                end

                            }))
                        end
                    end

                    return true
                end

            }))
        end,
    },
    {
        original = "c_ectoplasm",
        desc = {
            "{C:attention}Double{} your Joker Slots",
            "{C:attention}Half{} your Hand Size",
        },
        config = { extra = {} },
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            G.jokers:change_size(G.jokers.config.card_limit)
            G.hand:change_size(-(G.hand.config.card_limit / 2))
        end,
    },
    {
        original = "c_immolate",
        desc = {
            "Select {C:attention}one{} card",
            "{C:red}Destroy{} all cards in deck that share",
            "{C:attention}any{} properties with the selected card",
            "Earn {C:money}$#1#{} for each destroyed card",
        },
        config = { extra = { money = 3 } },
        can_use = function(self, card)
            return #G.hand.highlighted == 1 --hardcoded to be one, sorry </3
        end,
        use = function(self, card, area, copier)
            local selected = G.hand.highlighted[1]
            local suit = selected.base.suit
            local rank = selected.base.value
            local enh = next(SMODS.get_enhancements(selected))
            local edition = selected.edition and selected.edition.key

            local to_destroy = {}
            for _, playing_card in pairs(G.playing_cards) do
                if playing_card:is_suit(suit) or playing_card.base.value == rank or enh and (next(SMODS.get_enhancements(playing_card)) == enh) or (edition and edition == (playing_card.edition and playing_card.edition.key)) then
                    table.insert(to_destroy, playing_card)
                end
            end
            ease_dollars(card.ability.extra.money * #to_destroy)
            SMODS.destroy_cards(to_destroy)
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.money } }
        end
    },
    {
        original = "c_ankh",
        desc = {
            "Select {C:attention}one{} Joker",
            "{C:red}Destroy{} all other Jokers",
            "Create a {C:attention}new version{} of the selected Joker for each {C:red}destroyed{} Joker",
        },
        config = { extra = {} },
        can_use = function(self, card)
            return #G.jokers.highlighted == 1 --hardcoded to be one, sorry </3
        end,
        use = function(self, card, area, copier)
            local to_destroy = {}
            local sel = G.jokers.highlighted[1]
            for _, jkr in pairs(G.jokers.cards) do
                if jkr ~= sel then
                    table.insert(to_destroy, jkr)
                end
            end
            for i = 1, #to_destroy do
                SMODS.add_card({ key = sel.config.center.key, area = G.jokers })
            end
            SMODS.destroy_cards(to_destroy)
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.money } }
        end
    },
    {
        original = "c_deja_vu",
        desc = {
            "Add a {C:attention}Red Seal{} to up to {C:attention}#1#{} selected cards",
            "If only {C:attention}#2#{} card is selected, add an {C:attention}Entropic Seal{} instead",
        },
        config = { extra = { max = 3, min = 1 } },
        can_use = function(self, card)
            return #G.hand.highlighted >= card.ability.extra.min and #G.hand.highlighted <= card.ability.extra.max
        end,
        use = function(self, card, area, copier)
            if #G.hand.highlighted <= card.ability.extra.min then
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("valk_Entropic")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            else
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("Red")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            end
        end,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS.Red
            info_queue[#info_queue + 1] = G.P_SEALS.valk_Entropic
            return {
                vars = {
                    card.ability.extra.max, card.ability.extra.min
                }
            }
        end
    },
    {
        original = "c_hex",
        desc = {
            "Apply {C:attention}Cosmic, Lordly{} or {C:attention}R.G.B.{} to",
            "a random Joker, {C:red}destroy{} another random other Joker",
        },
        config = { extra = {} },
        can_use = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                if not joker.edition then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            local allowed = {}
            local notallowed = {}
            for _, joker in pairs(G.jokers.cards) do
                if not joker.edition then
                    table.insert(allowed, joker)
                end
            end
            local chosen_edition = pseudorandom_element({ "e_valk_lordly", "e_valk_cosmic", "e_valk_rgb" },
                "valk_tau_hex_edition")
            local chosen_joker = pseudorandom_element(allowed, "valk_tau_hex")

            for _, joker in pairs(G.jokers.cards) do
                if joker ~= chosen_joker then
                    table.insert(notallowed, joker)
                end
            end

            local to_kill = pseudorandom_element(notallowed, "valk_tau_hex_kill")
            chosen_joker:set_edition(chosen_edition)
            SMODS.destroy_cards({ to_kill })
        end,
    },
    {
        original = "c_trance",
        desc = {
            "Add a {C:attention}Blue Seal{} to up to {C:attention}#1#{} selected cards",
            "If only {C:attention}#2#{} card is selected, add a {C:attention}Galactic Seal{} instead",
        },
        config = { extra = { max = 3, min = 1 } },
        can_use = function(self, card)
            return #G.hand.highlighted >= card.ability.extra.min and #G.hand.highlighted <= card.ability.extra.max
        end,
        use = function(self, card, area, copier)
            if #G.hand.highlighted <= card.ability.extra.min then
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("valk_Galactic")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            else
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("Blue")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            end
        end,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS.Blue
            info_queue[#info_queue + 1] = G.P_SEALS.valk_Galactic
            return {
                vars = {
                    card.ability.extra.max, card.ability.extra.min
                }
            }
        end
    },
    {
        original = "c_medium",
        desc = {
            "Add a {C:attention}Purple Seal{} to up to {C:attention}#1#{} selected cards",
            "If only {C:attention}#2#{} card is selected, add a {C:attention}Vibrant Seal{} instead",
        },
        config = { extra = { max = 3, min = 1 } },
        can_use = function(self, card)
            return #G.hand.highlighted >= card.ability.extra.min and #G.hand.highlighted <= card.ability.extra.max
        end,
        use = function(self, card, area, copier)
            if #G.hand.highlighted <= card.ability.extra.min then
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("valk_Vibrant")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            else
                for _, c in pairs(G.hand.highlighted) do
                    c:set_seal("Purple")
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c.area:remove_from_highlighted(c)
                            return true
                        end,
                        trigger = "after"
                    }))
                end
            end
        end,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS.Purple
            info_queue[#info_queue + 1] = G.P_SEALS.valk_Vibrant
            return {
                vars = {
                    card.ability.extra.max, card.ability.extra.min
                }
            }
        end
    },
    {
        original = "c_cryptid",
        desc = {
            "Create {C:attention}#1#{} copy of all {C:attention}Selected{} Playing Cards",
        },
        config = { extra = { copies = 1 } },
        can_use = function(self, card)
            return #G.hand.highlighted >= 1
        end,
        use = function(self, card, area, copier)
            for _, c in pairs(G.hand.highlighted) do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for i = 1, card.ability.extra.copies do
                            local copy = copy_card(c)
                            copy:add_to_deck()
                            G.hand:emplace(copy)
                            table.insert(G.playing_cards, copy)
                        end
                        c.area:remove_from_highlighted(c)
                        return true
                    end,
                    trigger = "after"
                }))
            end
        end,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.copies
                }
            }
        end
    },
    {
        original = "c_soul",
        desc = {
            "Create a {C:legendary,E:1}Legendary{} Joker",
            "Apply {C:blue}Transformative{} to all Jokers",
        },
        config = { extra = {} },
        can_use = function(self, card)
            return (#G.jokers.cards < G.jokers.config.card_limit)
        end,
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({ rarity = "Legendary", set = "Joker" })
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                func = function()
                    for _, joker in pairs(G.jokers.cards) do
                        joker:add_sticker("valk_transformative", true)
                    end
                    return true 
                end
            }))
        end,
    },
    -- {
    --     original = "c_valk_succor",
    --     desc = {
    --         "",
    --     },
    --     config = { extra = {} },
    --     can_use = function(self, card)
            
    --     end,
    --     use = function(self, card, area, copier)
            
    --     end,
    -- },
}



for _, spectral in ipairs(tauspecs) do
    SMODS.Consumable {
        set = "TauSpec",
        cost = 4,
        atlas = "tspec",
        bases = { spectral.original },
        key = spectral.original .. "_tauic",
        pos = spectral_positions[spectral.original],
        soul_pos = spectral_soul_positions[spectral.original],
        can_use = spectral.can_use,
        use = spectral.use,
        loc_vars = spectral.loc_vars,
        loc_txt = {
            name = "Tauic " .. localize { type = "name_text", set = "Spectral", key = spectral.original },
            text = spectral.desc
        },
        config = spectral.config,
        in_pool = function()
            return false
        end,
        no_grc = true,
    }
end
