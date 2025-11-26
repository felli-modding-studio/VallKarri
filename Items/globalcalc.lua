vallkarri.calculate = function(self, context)
    vallkarri.refresh_ante_diff()

    if context.final_scoring_step then
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = "valk_final_scoring_step"}) --diff name to avoid morefluff conflict
        end
    end
    --ideally shouldnt affect anything else

    if vallkarri.metacalc then
        vallkarri.metacalc(context)
    end

    if vallkarri.challenge_calc then
        vallkarri.challenge_calc(context)
    end

    -- HAND BUFF CODE BELOW:
    if vallkarri.config.hand_buffs and context.final_scoring_step and next(G.GAME.applied_buffs) then

        local effects = {}

        for _,buff in ipairs(G.GAME.applied_buffs) do
            if vallkarri.hand_buff_functions[buff.key] then
                effects = SMODS.merge_effects({effects, vallkarri.hand_buff_functions[buff.key](buff.power, G.play.cards) or {}})
            end
        end

        SMODS.calculate_effect(effects, G.deck.cards[1] or G.deck)

    end
end
