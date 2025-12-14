VALK.UTILS.Tag {
    order = 1,
	key = "kitty",
	atlas = "tags",
	pos = { x = 0, y = 0 },
	config = { chips = 2 },
	loc_vars = function(self, info_queue, tag)
		return { vars = { tag.config.chips } }
	end,
	min_ante = 1e100, --just. dont spawn.
    calculate = function(self, tag, context)
        if context.final_scoring_step then
            return {
                chips = VALK.UTILS.count_kitty_tags() 
            }
        end
    end
}

VALK.UTILS.Tag {
    order = 1,
	key = "negativeeternal",
	atlas = "tags",
	pos = { x = 1, y = 0 },
	min_ante = 0,

	apply = function(self, tag, context)
		if context.type == "store_joker_modify" then
			local _applied = nil
			if not context.card.edition and not context.card.temp_edition and context.card.ability.set == "Joker" then
				local lock = tag.ID
				G.CONTROLLER.locks[lock] = true
				context.card.temp_edition = true
				tag:yep("+", G.C.DARK_EDITION, function()
					context.card:set_edition("e_negative", true)
					context.card.ability.eternal = true
					context.card.ability.couponed = true
					context.card:set_cost()
					context.card.temp_edition = nil
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
				_applied = true
				tag.triggered = true
			end
		end
	end
}