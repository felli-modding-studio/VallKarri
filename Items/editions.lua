-- don't expect any of these to come, unless someone wants to make some shaders for me

-- thhey here!

SMODS.Shader {
    key = "cosmic",
    path = "cosmic.fs"
}

SMODS.Edition {
    key = "cosmic",
    shader = "cosmic",
    loc_txt = {
        name = "Cosmic",
        label = "Cosmic",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips",
            shadercredit("Lily Felli")
        }
    },
    config = { echips = 1.05 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.edition and card.edition.echips or self.config.echips } }
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect({ echips = card.edition and card.edition.echips or 1.05 }, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    in_pool = function(self, args)
        return true
    end
}

SMODS.Shader {
    key = "glow",
    path = "glow.fs"
}

SMODS.Edition {
    key = "glow",
    shader = "glow",
    loc_txt = {
        name = "Glow-in-the-Dark",
        label = "Glow-in-the-Dark",
        text = {
            "Creates a {C:dark_edition}Negative{}",
            "{C:tarot}Tarot{} when hand played",
            shadercredit("Lily Felli")
        }
    },
    config = { extra = {} },
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.add_card({ set = "Tarot", area = G.consumeables, edition = "e_negative" })
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}

SMODS.Shader {
    key = "rgb",
    path = "rgb.fs"
}

SMODS.Edition {
    key = "rgb",
    shader = "rgb",
    loc_txt = {
        name = "R.G.B.",
        label = "R.G.B.",
        text = {
            "{C:mult}+#1#{} Mult and {X:mult,C:white}X#2#{} Mult",
            "{C:chips}+#1#{} Chips and {X:chips,C:white}X#2#{} Chips",
            shadercredit("Lily Felli")
        }
    },
    config = { mult = 5, xmult = 1.2, chips = 5, xchips = 1.2 },
    loc_vars = function(self, info_queue, card)
        -- print(self)
        return {
            vars = {
                card and card.edition and card.edition.mult or self.config.mult,
                card and card.edition and card.edition.xmult or self.config.xmult
            }
        }
    end,
    weight = 4,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect(
                {
                    mult = card.edition.mult,
                    chips = card.edition.mult,
                    xmult = card.edition.xmult,
                    xchips = card.edition.xchips
                }, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}

SMODS.Shader {
    key = "lowqual",
    path = "lowqual.fs"
}

-- SMODS.Edition {
local low_quality = {
    key = "lowqual",
    shader = "lowqual",
    loc_txt = {
        name = "Low Quality",
        label = "Low Quality",
        text = {
            "",
            shadercredit("Lily Felli")
        }
    },
    config = {},
    loc_vars = function(self, info_queue, card)
        -- print(self)
        return {
            vars = {

            }
        }
    end,
    weight = 4,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)

    end,
}

SMODS.Edition {
    key = "lordly",
    shader = false,
    loc_txt = {
        name = "Lordly",
        label = "Lordly",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            "Increase by {X:dark_edition,C:white}^#2#{} for each Joker owned",
            shadercredit("Lily Felli")
        }
    },
    config = { emult = 0.05, },
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect(
                {
                    emult = 1 + (card.edition.emult * #G.jokers.cards)
                }, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    weight = 1,
    get_weight = function(self)
        local found = SMODS.find_card("j_valk_lily")
        local n = next(found) and found[1].ability.extra.rate or 1
        return G.GAME.edition_rate * self.weight * (n ^ #SMODS.find_card("j_valk_lily"))
    end,
    loc_vars = function(self, info_queue, card)
        local em = card and card.edition and card.edition.emult or self.config.emult
        return {
            vars = {
                1 + (em * (G.jokers and #G.jokers.cards or 0)),
                em
            }
        }
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}


SMODS.Edition {
    key = "censored",
    shader = false,
    loc_txt = {
        name = "Censored",
        label = "Censored",
        text = {
            "All values are {C:attention}Hidden{}",
            "Retrigger this card {C:attention}twice{}",
        }
    },
    config = {},
    calculate = function(self, card, context)
        if context.other_card == card and ((context.repetition and context.cardarea == G.play) or (context.retrigger_joker_check and not context.retrigger_joker)) then
            return {
                repetitions = 2
            }
        end
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {

            }
        }
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}

SMODS.Shader {
    key = "temperature",
    path = "temperature.fs",
}

SMODS.Edition {
    key = "iceandfire",
    shader = "temperature",
    loc_txt = {
        name = "Ice and Fire",
        label = "Ice and Fire",
        text = {
            "Retrigger the card to the left {C:attention}twice{}",
            "{X:chips}X#1#{} Chips",
            "{X:mult}X#1#{} Mult"
        }
    },
    config = {x = 1.1},
    calculate = function(self, card, context)
        if (context.retrigger_joker_check and not context.retrigger_joker) and context.other_card == card.area.cards[vallkarri.index(card)-1] then
            return {
                repetitions = 2
            }
        end

        if context.main_scoring and context.cardarea == G.play and card.area.cards[vallkarri.index(card)-1] then --this is dumb but i calculate it twice so that its not calculated in every context b.c. short circuit
            local other_card = card.area.cards[vallkarri.index(card)-1]
            for i=1,2 do SMODS.score_card(other_card, context) end
        end

        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect({xchips = card.edition.x, xmult = card.edition.x}, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
        
    end,
    weight = 2,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card and card.edition and card.edition.x or self.config.x
            }
        }
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}
