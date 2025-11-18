local lc = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        lc()
    end
    G.ARGS.LOC_COLOURS.valk_cataclysm = HEX("50202A")
    return lc(_c, _default)
end

G.C.VALK_CATACLYSM = HEX("50202A")

SMODS.Atlas {
    key = "cata",
    path = "cataclysm.png",
    px = 83,
    py = 103,
}

SMODS.ConsumableType {
    key = "Cataclysm",
    collection_rows = { 6, 6 },
    primary_colour = HEX("3D2228"),
    secondary_colour = HEX("69454D"),
    shop_rate = 0,

    loc_txt = {
        collection = "Cataclysm Cards",
        label = "cataclysm",
        name = "Cataclysm Cards",
        undiscovered = {
            name = "Mysterious Disaster",
            text = {
                "Unlock this {C:valk_cataclysm}Cataclysm{}",
                "by using it in a run"
            }
        }
    },
}

local function sanitize(str)
    str = str:lower()
    str = str:gsub(" ", "_")
    return str
end

local cataclysms = {
    {
        name = "Deluge",
        pos = { x = 0, y = 0 },
        downside_while_eternal = { "{C:attention}De-level{} played {C:attention}poker hands{}" },
        after_rounds_use = { "{C:attention}Triple{} the scaling on all {C:attention}poker hands{}" },
        rounds = 2,
        calculate = function(self, card, context)
            if context.before then
                SMODS.smart_level_up_hand(card, context.scoring_name, false, -1)
            end
        end,
        use = function(self, card)
            vallkarri.multiply_all_hand_scaling(3)
        end
    },
    {
        name = "Doomsday",
        pos = { x = 1, y = 0 },
        downside_while_eternal = { "Multiply Joker values by {C:attention}X#1#{} at end of round" },
        after_rounds_use = { "Undo all {C:attention}Value Manipulation{} on all Jokers", "then multiply their values by {C:attention}X#2#{}" },
        config = { loss = 0.85, gain = 3 },
        rounds = 4,
        calculate = function(self, card, context)
            if context.end_of_round and context.main_eval then
                for _, joker in pairs(G.jokers.cards) do
                    Cryptid.manipulate(joker, { value = card.ability.extra.vars.loss })
                end
            end
        end,
        use = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                Cryptid.manipulate(joker, { value = 1, dont_stack = true })
                Cryptid.manipulate(joker, { value = card.ability.extra.vars.gain })
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.loss, card.ability.extra.vars.gain } }
        end
    },
    {
        name = "Paroxysm",
        pos = { x = 2, y = 0 },
        downside_while_eternal = { "Destroy {C:attention}leftmost{} Joker at end of round" },
        after_rounds_use = { "Multiply all Joker values by {C:attention}X#1#{}" },
        config = { gain = 3 },
        rounds = 3,
        calculate = function(self, card, context)
            if context.end_of_round and context.main_eval and #G.jokers.cards > 0 then
                SMODS.destroy_cards({ G.jokers.cards[1] })
            end
        end,
        use = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                Cryptid.manipulate(joker, { value = card.ability.extra.vars.gain })
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.gain } }
        end
    },
    {
        name = "Invasion",
        pos = { x = 3, y = 0 },
        downside_while_eternal = { "Lose all {C:red}Discards{} when Blind selected" },
        after_rounds_use = { "{C:attention}+#1#{} Consumable slots" },
        config = { gain = 3 },
        rounds = 3,
        calculate = function(self, card, context)
            if context.setting_blind then
                ease_discard(-G.GAME.current_round.discards_left)
            end
        end,
        use = function(self, card)
            G.consumeables:change_size(card.ability.extra.gain)
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.gain } }
        end
    },
    {
        name = "Absolution",
        pos = { x = 4, y = 0 },
        downside_while_eternal = { "Fill empty Joker slots with random {C:common}Common{} Jokers, then", "make all Jokers {C:purple}Eternal{}" },
        after_rounds_use = { "Remove {C:purple}Eternal{} from all Jokers, then ", "create a {C:attention}copy{} of a random Joker" },
        config = {},
        rounds = 2,
        calculate = function(self, card, context)
            if context.setting_blind then
                ease_discard(-G.GAME.current_round.discards_left)
            end
        end,
        use = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                joker:set_eternal_bypass(false)
            end

            local to_copy = pseudorandom_element(G.jokers.cards, "valk_absolution")
            local new = copy_card(to_copy)
            new:add_to_deck()
            G.jokers:emplace(new)
        end,
        activate = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                joker:set_eternal_bypass(true)
            end

            for i = 1, G.jokers.config.card_limit - G.jokers.config.card_count do
                SMODS.add_card({ set = "Joker", rarity = "Common" })
            end
        end,
    },
    {
        name = "Plague",
        pos = { x = 5, y = 0 },
        downside_while_eternal = { "Destroy {C:attention}rightmost{} card in scoring hands" },
        after_rounds_use = {
            "Select up to {C:attention}#1#{} cards,",
            "apply random {C:attention}Editions{} and {C:attention}Seals{} to them,",
            "then make {C:attention}two{} copies of all selected cards"
        },
        config = { cards = 5 },
        rounds = 2,
        calculate = function(self, card, context)
            if context.before and #context.scoring_hand > 0 then
                SMODS.destroy_cards({ context.scoring_hand[#context.scoring_hand] })
            end
        end,
        use = function(self, card)
            for _, playing_card in pairs(G.hand.highlighted) do
                playing_card:set_ability(SMODS.poll_enhancement({ guaranteed = true, key = "valk_plague" }))
                playing_card:set_seal(SMODS.poll_seal({ guaranteed = true, key = "valk_plague_seal" }), true)
                for i = 1, 2 do
                    local copy = copy_card(playing_card)
                    copy:add_to_deck()
                    G.hand:emplace(copy)
                end
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.cards } }
        end,
        can_use = function(self, card)
            return (#G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.vars.cards)
        end

    },
    {
        name = "Disaster",
        pos = { x = 6, y = 0 },
        downside_while_eternal = { "{C:attention}-#1#{} Hand Size at end of round" },
        after_rounds_use = {
            "{C:attention}+#1#{} Hand Size",
            "{C:attention}Double{} all Joker values"
        },
        config = { handsize = 1 },
        rounds = 2,
        calculate = function(self, card, context)
            if context.end_of_round and context.main_eval then
                G.hand:change_size(-card.ability.extra.vars.handsize)
            end
        end,
        use = function(self, card)
            G.hand:change_size(card.ability.extra.vars.handsize)
            for _, joker in pairs(G.jokers.cards) do
                Cryptid.manipulate(joker, { value = 2 })
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.handsize } }
        end,

    },
    {
        name = "Collision",
        pos = { x = 7, y = 0 },
        downside_while_eternal = { "{C:red}Banish{} all used {C:planet}Planet{} cards" },
        after_rounds_use = {
            "All future {C:tarot}Tarot{} cards have {C:attention}Double{} values"
        },
        config = {},
        rounds = 4,
        calculate = function(self, card, context)
            if context.using_consumeable and context.consumeable.config.center.set == "Planet" then
                G.GAME.banned_keys[context.consumeable.config.center_key] = true
                context.consumeable:start_dissolve({ G.C.RED })
            end
        end,
        use = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Tarot) do
                G.GAME.vallkarri.spawn_multipliers[entry.key] = G.GAME.vallkarri.spawn_multipliers[entry.key] * 2
            end
        end,
    },
    {
        name = "Takeover",
        pos = { x = 8, y = 0 },
        downside_while_eternal = { "{C:attention}-#1#{} Consumable Slots" },
        after_rounds_use = {
            "{C:attention}+#1#{} Hand Size"
        },
        config = { cost = 3 },
        rounds = 4,
        use = function(self, card)
            G.consumeables:change_size(card.ability.extra.vars.cost)
            G.hand:change_size(card.ability.extra.vars.cost)
        end,
        activate = function(self, card)
            G.consumeables:change_size(-card.ability.extra.vars.cost)
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.cost } }
        end,
    },
    {
        name = "Maleficence",
        pos = { x = 0, y = 1 },
        downside_while_eternal = { "Destroy all {C:attention}Editioned{} Jokers" },
        after_rounds_use = {
            "Apply a random {C:attention}Edition{} to all Jokers"
        },
        config = {},
        rounds = 3,
        use = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                joker:set_edition(poll_edition("valk_maleficence", nil, nil, true))
            end
        end,
        activate = function(self, card)
            local to_destroy = {}

            for _, joker in pairs(G.jokers.cards) do
                if joker.edition then
                    table.insert(to_destroy, joker)
                end
            end

            SMODS.destroy_cards(to_destroy)
        end,
    },
    {
        name = "Rip",
        pos = { x = 1, y = 1 },
        downside_while_eternal = { "{C:planet}Planet{} cards cannot be used" },
        after_rounds_use = {
            "{C:attention}Triple{} the scaling on all {C:attention}poker hands{}"
        },
        config = {},
        rounds = 3,
        use = function(self, card)
            vallkarri.multiply_all_hand_scaling(3)
            for _, entry in pairs(G.P_CENTER_POOLS.Planet) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = false
            end
        end,
        activate = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Planet) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = true
            end
        end,
    },
    {
        name = "Crunch",
        pos = { x = 2, y = 1 },
        downside_while_eternal = { "{C:tarot}Tarot{} cards cannot be used" },
        after_rounds_use = {
            "All future {C:tarot}Tarot{} cards have {C:attention}Double{} values"
        },
        config = {},
        rounds = 3,
        use = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Tarot) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = false
                G.GAME.vallkarri.spawn_multipliers[entry.key] = G.GAME.vallkarri.spawn_multipliers[entry.key] * 2
            end
        end,
        activate = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Tarot) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = true
            end
        end,
    },
    {
        name = "Heat Death",
        pos = { x = 3, y = 1 },
        downside_while_eternal = { "{C:tarot}Tarot{} and {C:spectral}Spectral{} cards cannot be used" },
        after_rounds_use = {
            "{C:attention}Hidden{} {C:spectral}Spectral{} cards have a {C:green}#1#%{} chance",
            "to replace {C:attention}non-hidden{} {C:spectral}Spectral{} cards"
        },
        config = { chance = 10 },
        rounds = 3,
        use = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Tarot) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = false
            end

            for _, entry in pairs(G.P_CENTER_POOLS.Spectral) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = false
            end

            if not G.GAME.hidden_override then
                G.GAME.hidden_override = card.ability.extra.vars.chance
            else
                G.GAME.hidden_override = G.GAME.hidden_override + card.ability.extra.vars.chance
            end
        end,
        activate = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Tarot) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = true
            end

            for _, entry in pairs(G.P_CENTER_POOLS.Spectral) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = true
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.chance } }
        end,
    },
    {
        name = "Vacuum Decay",
        pos = { x = 4, y = 1 },
        downside_while_eternal = { "Cannot buy {C:attention}Jokers{} from the Shop" },
        after_rounds_use = {
            "Create {C:attention}#1#{} {C:dark_edition}Negative{} {C:rare}Rare{} Jokers"
        },
        config = { jokers = 3 },
        rounds = 3,
        use = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Joker) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = false
            end

            for i = 1, card.ability.extra.vars.jokers do
                SMODS.add_card({ set = "Joker", edition = "e_negative", rarity = "Rare" })
            end
        end,
        activate = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Joker) do
                G.GAME.vallkarri.banned_use_keys[entry.key] = true
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.jokers } }
        end,
    },
    {
        name = "Occulture",
        pos = { x = 5, y = 1 },
        downside_while_eternal = { "{C:attention}Skip Tags{} are not obtainable" },
        after_rounds_use = {
            "All future {C:spectral}Spectral{} cards have {C:attention}double{} values"
        },
        config = { jokers = 3 },
        rounds = 4,
        use = function(self, card)
            for _, entry in pairs(G.P_CENTER_POOLS.Spectral) do
                G.GAME.vallkarri.spawn_multipliers[entry.key] = G.GAME.vallkarri.spawn_multipliers[entry.key] * 2
            end
            G.GAME.ban_tags = false
        end,
        activate = function(self, card)
            G.GAME.ban_tags = true
        end,
    },
    {
        name = "Post-Existence",
        pos = { x = 6, y = 1 },
        downside_while_eternal = { "{C:red}Banish{} all used {C:tarot}Tarot{} cards" },
        after_rounds_use = {
            "{C:spectral}Spectral{} cards may spawn in the Shop",
        },
        config = { rate_inc = 4 },
        rounds = 4,
        calculate = function(self, card, context)
            if context.using_consumeable and context.consumeable.config.center.set == "Tarot" then
                G.GAME.banned_keys[context.consumeable.config.center_key] = true
                context.consumeable:start_dissolve({ G.C.RED })
            end
        end,
        use = function(self, card)
            G.GAME.spectral_rate = G.GAME.spectral_rate + card.ability.extra.vars.rate_inc
        end,
    },
    {
        name = "Stagnancy",
        pos = { x = 7, y = 1 },
        downside_while_eternal = { "All owned Jokers become {C:purple}Eternal{}" },
        after_rounds_use = {
            "Remove {C:purple}Eternal{} from all Jokers",
            "Create an {C:purple}Eternal{} {C:valk_exquisite}Exquisite{} Joker",
        },
        config = {},
        rounds = 6,
        activate = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                joker:set_eternal_bypass(true)
            end
        end,
        use = function(self, card)
            for _, joker in pairs(G.jokers.cards) do
                joker:set_eternal_bypass(false)
            end

            local newjoker = SMODS.add_card({ set = "Joker", rarity = "valk_exquisite" })
            newjoker:set_eternal_bypass(true)
        end,
    },
    {
        name = "Tempest",
        pos = { x = 8, y = 1 },
        downside_while_eternal = { "{X:dark_edition,C:white}X#1#{} Blind Size" },
        after_rounds_use = {
            "Add {C:attention}#2# $1 Vouchers{} to the current shop",
        },
        config = { mul = 1.25, vouch = 2, cost = 0 },
        rounds = 3,
        calculate = function(self, card, context)
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.vars.mul
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end,
        use = function(self, card, context)
            for i = 1, card.ability.extra.vars.vouch do
                local voucher_key = get_next_voucher_key(true)
                G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1
                local new_card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w / 2,
                    G.shop_vouchers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[voucher_key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true })
                new_card.bonus_cost = ((new_card.cost) * (card.ability.extra.vars.cost - 1)) - 1
                new_card:set_cost()
                create_shop_card_ui(new_card, 'Voucher', G.shop_vouchers)
                new_card:start_materialize()
                G.shop_vouchers:emplace(new_card)
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.vars.mul, card.ability.extra.vars.vouch } }
        end,
        can_use = function(self, card)
            return (G.STATE == G.STATES.SHOP)
        end
    },
    {
        name = "Leviathan",
        pos = { x = 0, y = 2 },
        downside_while_eternal = { "Nothing!" },
        after_rounds_use = {
            "Create {C:attention}two{} {C:valk_cataclysm}Cataclysm{} cards",
            "{C:inactive}(Does not require room)",
        },
        config = {},
        rounds = 4,
        use = function(self, card)
            for i = 1, 2 do
                SMODS.add_card({ set = "Cataclysm", area = G.consumeables })
            end
        end,
    },
}

for _, cata in pairs(cataclysms) do
    if not cata.loc_vars then cata.loc_vars = function() end end
    if not cata.can_use then cata.can_use = function() return true end end
    if not cata.use then cata.use = function() end end
    if not cata.calculate then cata.calculate = function() end end
    SMODS.Consumable {
        set = "Cataclysm",
        key = sanitize(cata.name),
        loc_txt = {
            name = cata.name,
            text = {
                {
                    "Use this card to turn it {C:purple}Eternal{} for {C:attention}#10#{} Rounds",
                    "While {C:purple}Eternal{}, applies the {C:red,s:1.2}Downside{}",
                    "Once time is up, you may use this card to apply the {C:green,s:1.2}Upside{}",
                    "{C:inactive}({C:attention}#11#{C:inactive} of {C:attention}#10#{C:inactive} Rounds remaining)"
                },
                vallkarri.merge_lists({ "{s:1.5,C:red}Downside" }, cata.downside_while_eternal),
                vallkarri.merge_lists({ "{s:1.5,C:green}Upside" }, cata.after_rounds_use),
            }
        },
        pos = cata.pos or { x = 0, y = 0 },
        atlas = cata.atlas or "cata",
        display_size = cata.display_size or { w = 83, h = 103 },
        valk_artist = cata.artist or "Pangaea",

        config = { extra = { start_rounds = cata.rounds, rounds = cata.rounds, ready = false, vars = cata.config } },

        loc_vars = function(self, info_queue, card)
            local ret = cata.loc_vars(self, info_queue, card) or { vars = {} }
            ret.vars[10] = card.ability.extra.start_rounds
            ret.vars[11] = card.ability.extra.rounds
            return ret
        end,
        can_use = function(self, card)
            local can_use = true
            if cata.can_use then
                can_use = cata.can_use(self, card)
            end

            return (not card.ability.extra.ready and not card:is_eternal()) or
                (can_use and card.ability.extra.ready)
        end,
        use = function(self, card, area, copier)
            if (not card:is_eternal()) and (not card.ability.extra.ready) then
                card:set_eternal_bypass(true)
                if cata.activate then
                    cata.activate(self, card)
                end
                return
            end

            return cata.use(self, card, area, copier)
        end,
        keep_on_use = function(self, card)
            return not card.ability.extra.ready
        end,
        calculate = function(self, card, context)
            local ret
            if card:is_eternal() and not card.ability.extra.ready then
                ret = cata.calculate(self, card, context)
            end



            if (context.end_of_round and context.main_eval and card:is_eternal()) and not card.ability.extra.ready then
                card.ability.extra.rounds = card.ability.extra.rounds - 1
                quick_card_speak(card, "-1 " .. localize("k_round"))
                if card.ability.extra.rounds < 1 then
                    card:set_eternal_bypass(false)
                    juice_card_until(card, function() return true end)
                    card.ability.extra.ready = true
                end
            end



            return ret
        end,
        no_doe = true,
        no_grc = true,
        cost = 16,
    }
end


SMODS.Booster {
    key = "revelations",
    atlas = "cata",
    pos = { x = 0, y = 3 },
    display_size = { w = 83, h = 103 },
    discovered = true,
    loc_txt = {
        name = "Pack of Revelations",
        text = {
            "Pick {C:attention}#1#{} of up to {C:attention}#2#{} {C:valk_cataclysm}Cataclysm{} cards",
            "to use immediately",
        },
        group_name = "Pack of Revelations"
    },
    valk_artist = "Pangaea",
    draw_hand = false,
    config = { choose = 1, extra = 3 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 0.999,
    cost = 18,

    create_card = function(self, card, i)
        ease_background_colour(G.C.VALK_CATACLYSM)
        return create_card("Cataclysm", G.pack_cards, nil, nil, true, nil, nil, "valk_pack_of_revelations")
    end,

    in_pool = function()
        return #SMODS.find_card("v_valk_seventrumpets") > 0
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "nevada",
    loc_txt = {
        name = "Nevada",
        text = {
            "{C:attention}Double{} Chips and Mult per level for all hands",
            "for each {C:valk_cataclysm}Cataclysm Card{} used",
        }
    },
    valk_artist = "Pangaea",
    no_doe = true,

    config = { extra = { increase = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.increase } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        for name, center in pairs(G.GAME.consumeable_usage) do
            if G.P_CENTERS[name].set == "Cataclysm" then
                levels = levels + center.count
            end
        end

        local value = 2 ^ levels
        vallkarri.xl_chipsmult_allhands(card, value, value)
    end,
    in_pool = function()
        for name, center in pairs(G.GAME.consumeable_usage) do
            if G.P_CENTERS[name].set == "Cataclysm" then
                return true
            end
        end
        return false
    end,


    atlas = "csm",
    pos = { x = 9, y = 2 },
    no_grc = true,
    no_doe = true,
    dependencies = { "Talisman" },

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Voucher {
    key = "seventrumpets",
    atlas = "main",
    pos = { x = 2, y = 8 },
    loc_txt = {
        name = "Seven Trumpets",
        text = {
            "The {C:valk_cataclysm}Pack of Revelations{} can now appear in the shop",
        }
    },
    valk_artist = "Pangaea",
}
