if not CardSleeves then
    return
end

SMODS.Atlas {
    key = "slev",
    path = "sleeves.png",
    px = 73,
    py = 95,}

CardSleeves.Sleeve {
    key = "s_encore",
    name = "Encore Sleeve",
    atlas = "slev",
    loc_txt = {
        name = "Encore Sleeve",
        text = {
            "After hand scores,",
            "all {C:attention}end-of-round{}",
            "effects are triggered",
        }
    },
    pos = { x = 0, y = 0 },
    unlocked = true,
    loc_vars = function(self, info_queue, card)
    end,
        calculate = function(center, back, context)

        if context.after then
            
            SMODS.calculate_context({end_of_round = true, main_eval = true})

        end

    end,
}

if vallkarri_config.hand_buffs then
    CardSleeves.Sleeve {
        key = "s_handbuffdeck",
        valk_artist = nil,
        config = { hand_size = -1, requirement = 2, alt_req = 1 },
        pos = { x = 2, y = 0 },
        atlas = "slev",
        loc_vars = function(self, info_queue, card)
            local key=self.key
            local sizemod = self.config.hand_size
            if self.get_current_deck_key() == "b_valk_handbuffdeck" then
                key = key.."_alt"
                sizemod = sizemod + self.config.hand_size
            end
            return {
                key = key,
                vars = { self.config.requirement, sizemod, self.config.alt_req } 
            }
        end,
        apply = function(self, back)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.buff_requirement = self.config.requirement
                    G.hand:change_size(self.config.hand_size)
                    if self.get_current_deck_key() == "b_valk_handbuffdeck" then
                        G.GAME.buff_requirement = self.config.alt_req
                        G.hand:change_size(self.config.hand_size)
                    end
                    return true
                end
            }))
        end,
        calculate = function (self, sleeve, context)
            if not (self.get_current_deck_key() == "b_valk_handbuffdeck") then return end
            if context.setting_ability and context.other_card then
                sendDebugMessage("Setting ability...")
                if context.other_card.ability and context.other_card.ability.consumeable and context.other_card.ability.consumeable.mod_conv then
                    sendDebugMessage("Card has mod_conv...", "Vall-Karri")
                    context.other_card.ability.consumeable.max_highlighted = 1
                end
            end
        end
    }
end