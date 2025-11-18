SMODS.Atlas {
    key = "seals",
    path = "seals.png",
    px = 71,
    py = 95,
}

SMODS.Seal {
    key = "Gilded",
    config = { extra = { money = 5 } },
    badge_colour = G.C.VALK_FIRE,
    loc_txt = {
        name = "Gilded Seal",
        label = "Gilded Seal",
        text = {
            "Earn {C:money}$#1#{} when scored",
            "Gives chips equal to {C:attention}Double{} your current {C:money}money{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.money
            }
        }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            SMODS.calculate_effect({ dollars = card.ability.seal.extra.money, extra = { chips = G.GAME.dollars*2 } }, card)
        end
    end,
    pos = { x = 0, y = 0 }, --vanilla gold seal, change when sprite
    atlas = "seals"
}

SMODS.Seal {
    key = "Entropic",
    config = { extra = { numerator = 1, denominator = 5, gain = 1} },
    badge_colour = G.C.VALK_GURPLE,
    loc_txt = {
        name = "Entropic Seal",
        label = "Entropic Seal",
        text = {
            "Retrigger once for every card {C:attention}held-in-hand{}",
            "{C:green}#1# in #2#{} Chance to {C:red,E:1}self-destruct{} when triggered",
            "Increase denominator by {C:attention}#3#{} when triggered"
        }
    },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, Cryptid.safe_get(card, "ability", "seal", "extra", "numerator") or self.config.extra.numerator, Cryptid.safe_get(card, "ability", "seal", "extra", "denominator") or self.config.extra.denominator)
        return {
            vars = {
                num, den, self.config.extra.gain
            }
        }
    end,
    calculate = function(self, card, context)
        
        if context.main_scoring and context.cardarea == G.play then
            local ex = card.ability.seal.extra
            local roll = SMODS.pseudorandom_probability(card, "entropic_seal", ex.numerator, ex.denominator)
            if roll then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards({ card })
                        return true
                    end,
                    trigger = "after"
                }))
            else
                card.ability.seal.extra.denominator = card.ability.seal.extra.denominator + card.ability.seal.extra.gain
            end
        end

        if context.repetition then
            return {
                repetitions = #G.hand.cards
            }
        end
    end,
    pos = { x = 2, y = 0 }, --vanilla gold seal, change when sprite
    atlas = "seals"
}

SMODS.Seal {
    key = "Galactic",
    badge_colour = G.C.VALK_BLUE,
    loc_txt = {
        name = "Galactic Seal",
        label = "Galactic Seal",
        text = {
            "When {C:attention}held-in-hand{}, create a {C:attention}Black Hole{}",
            "{C:inactive}(Must have room)",
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.hand and (G.consumeables.config.card_count + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                func = function()
                    SMODS.add_card({key = "c_black_hole"})
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                    return true
                end
            }))
            return { message = "+1 " .. localize{type="name_text",set="Spectral",key="c_black_hole"}, colour = G.C.SECONDARY_SET.Spectral}
        end
    end,
    pos = { x = 3, y = 0 }, --vanilla gold seal, change when sprite
    atlas = "seals"
}

SMODS.Seal {
    key = "Vibrant",
    badge_colour = G.C.VALK_PRESTIGIOUS,
    loc_txt = {
        name = "Vibrant Seal",
        label = "Vibrant Seal",
        text = {
            "Creates a {C:tarot}Tarot{} card when {C:attention}discarded{}",
            "Creates a {C:spectral}Spectral{} card when {C:attention}scored{}",
            "{C:inactive}(Must have room)",
        }
    },
    calculate = function(self, card, context)
        --code mostly taken from vremade, thank you N' <3
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end

        if context.main_scoring and context.cardarea == G.play and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Spectral' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral }
        end
    end,
    pos = { x = 1, y = 0 }, --vanilla gold seal, change when sprite
    atlas = "seals"
}