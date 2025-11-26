SMODS.Rarity {
    key = 'exquisite',
    loc_txt = {
        name = 'Exquisite'
    },
    badge_colour = G.C.VALK_EXQUISITE,
    pools = { ["Joker"] = false },
}

SMODS.Joker {
    key = "illena",
    loc_txt = {
        name = "Illena Vera",
        text = {
            "{C:chips}+#1#{} Chips",
            "Balance all {C:attention}Joker values{} at end of round",
            "Gains the values of {C:attention}Sold Jokers{} as Chips",

            quote("illena"),
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { chips = 100 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pools = { ["Kitties"] = true },
    pos = { x = 0, y = 2 },
    soul_pos = { x = 1, y = 2 },
    cost = 35,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local sum = 0
            local amount = 0
            for _, joker in pairs(G.jokers.cards) do
                if not joker.config.center.immutable then
                    local s, c = vallkarri.recursive_sum(joker.ability)
                    sum = sum + s
                    amount = amount + c
                end
            end

            for _, joker in pairs(G.jokers.cards) do
                if not joker.config.center.immutable then
                    vallkarri.recursive_set(joker.ability, sum / amount)
                end
            end


            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("gong", 0.94, 0.3)
                    play_sound("gong", 0.94 * 1.5, 0.2)
                    attention_text({
                        scale = 1.3,
                        text = localize("k_balanced"),
                        hold = 2,
                        align = 'cm',
                        offset = { x = 0, y = -2.7 },
                        major = G.play
                    })
                    return true
                end
            }))
        end

        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end

        if context.selling_card and context.card.area == G.jokers then
            card.ability.extra.chips = card.ability.extra.chips + vallkarri.recursive_sum(context.card.ability)
            quick_card_speak(card, localize("k_upgrade_ex"))
        end
    end,
    lore = {
        "Illena is a Fellinian, who was in her early life used as a",
        "test subject by the EMC, causing her to develop psychic powers.",
        "",
        "These powers allow her to read the mind of people, initially",
        "being a weak form of mind reading, which becomes stronger over time.",
        "",
        "She chooses to isolate herself from people, but also cares for people.",
        "This makes it a tough balance between her sanity and her empathy.",
        "",
        "Illena's extreme obsession with people and their mental makes her unreliable",
        "in other parts of life, often forgetting to take care of herself."
    }
}

SMODS.Joker {
    key = "arris",
    loc_txt = {
        name = "Arris",
        text = {
            "{C:valk_superplanet}Superplanets{} appear {C:attention}X#1#{} more frequently in the shop",
            "Using a {C:valk_superplanet}Superplanet{} generates {C:attention}#2#{} random {C:planet}Planetoids{}",
            "Using a {C:planet}Planetoid{} generates {C:attention}#2#{} random {C:planet}Planets{}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { rate = 200, copies = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rate, card.ability.extra.copies } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = { x = 8, y = 14 },
    soul_pos = { x = 9, y = 14 },
    cost = 35,
    demicoloncompat = true,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.config.center.set == "Superplanet" then
            for i = 1, card.ability.extra.copies do
                local c = create_card("Planetoid", G.consumeables, nil, nil, nil, nil, nil, "valk_arris")
                c:add_to_deck()
                G.consumeables:emplace(c)
            end
            quick_card_speak(card, "We have much to discover, don't we?")
        end

        if context.using_consumeable and context.consumeable.config.center.set == "Planetoid" then
            for i = 1, card.ability.extra.copies do
                local c = create_card("Planet", G.consumeables, nil, nil, nil, nil, nil, "valk_arris")
                c:add_to_deck()
                G.consumeables:emplace(c)
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.superplanet_rate = G.GAME.superplanet_rate * card.ability.extra.rate
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.superplanet_rate = G.GAME.superplanet_rate / card.ability.extra.rate
        end
    end,

    lore = {
        "A 23 year old skeleton who was transformed into such ",
        "due to an incorrect death, as well as his family.",
        "",
        "Not much is known about his human life, ",
        "other than the fact that he had yellow hair and yellow eyes.",
        "",
        "Cursed with this second chance at life, he tries to make the most out of every day,",
        "no matter how much pain he went through, and unknown to him...",
        "...he is about to go through so much more. ",
        "",
        "He likes to spend his days going on walks or spending time in the park,",
        "embracing the wild life that goes about."
    }
}


SMODS.Joker {
    key = "libratpondere",
    loc_txt = {
        name = "Librat Pondere",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips per {C:blue}blue team{} member in the {C:attention}VallKarri{} discord server",
            "{X:dark_edition,C:white}^#2#{} Mult per {C:red}red team{} member in the {C:attention}VallKarri{} discord server",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#3#{C:inactive} Chips and {X:dark_edition,C:white}^#4#{C:inactive} Mult)",
            "{V:1,S:0.5}https://discord.gg/5d3HWu88yn{}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { perblue = 0.02, perred = 0.02 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.perblue,
                card.ability.extra.perred,
                1 + (card.ability.extra.perblue * vallkarri.librat_vals.blue),
                1 + (card.ability.extra.perred * vallkarri.librat_vals.red),
                colours = {
                    HEX("7289DA")
                }
            }
        }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = { x = 7, y = 5 },
    soul_pos = { x = 9, y = 5, extra = { x = 8, y = 5 } },
    cost = 35,
    demicoloncompat = true,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        -- vallkarri.librat_vals.blue, vallkarri.librat_vals.red

        if context.joker_main then
            return {
                emult = 1 + (card.ability.extra.perred * vallkarri.librat_vals.red),
                echips = 1 + (card.ability.extra.perblue * vallkarri.librat_vals.blue)
            }
        end
    end
}

-- SMODS.Joker {
local scraptake = { --temp disabled due to tauics being moved to another mod
    key = "scraptake",
    loc_txt = {
        name = "Scraptake",
        text = {
            "{C:valk_tauic}Tauic{} Jokers are {X:valk_tauic,C:white}X#1#{} more likely to spawn",
            "Multiply this by {C:attention}X#2#{} at end of round",
            "Give {X:dark_edition,C:white}^Mult{} equal to Tauic probability",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#3#{C:inactive} Mult)",
            quote("scraptake"),
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { prob = 1, x = 1.025 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = vallkarri.get_tau_probability_vars("", 1, 0)
        return { vars = { card.ability.extra.prob, card.ability.extra.x, numerator } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = { x = 7, y = 0 },
    soul_pos = { x = 9, y = 0, extra = { x = 8, y = 0 } },
    cost = 35,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            SMODS.scale_card(card,
                { ref_table = card.ability.extra, ref_value = "prob", scalar_value = "x", operation = "X" })
        end

        if context.joker_main then
            local numerator, denominator = vallkarri.get_tau_probability_vars("", 1, 0)
            return { emult = numerator }
        end
    end,
}

SMODS.Joker {
    key = "madstone_whiskey",
    loc_txt = {
        name = "Madstone Whiskey",
        text = {
            "When a booster pack is skipped, create a {C:dark_edition}Negative{} {C:attention}The Fool{}",
            "When {C:attention}The Fool{} is used, create {C:attention}#1#{} random tag",
            "Increase by {C:attention}#2#{} when {C:attention}Boss Blind{} defeated",
        }
    },
    valk_artist = "Pangaea",
    config = { extra = { tags = 1, increase = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.tags, card.ability.extra.increase } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = { x = 5, y = 12 },
    soul_pos = { x = 5, y = 13, extra = { x = 5, y = 14 } },
    cost = 35,
    immutable = true,
    calculate = function(self, card, context)
        if context.skipping_booster then
            local fool = SMODS.create_card({ key = "c_fool", edition = "e_negative" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end

        if context.using_consumeable and context.consumeable and context.consumeable.config.center.key == "c_fool" then
            for i = 1, card.ability.extra.tags do
                add_random_tag("valk_madstone_whiskey")
            end
        end

        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            card.ability.extra.tags = card.ability.extra.tags + card.ability.extra.increase
            card.ability.extra.tags = math.min(card.ability.extra.tags, 40)
            card.ability.extra.increase = math.min(card.ability.extra.increase, 40)
        end
    end,
}

SMODS.Joker {
    key = "astracola",
    loc_txt = {
        name = "Astracola",
        text = {
            "Create {C:attention}#1# Meteor Tags{} when blind skipped",
            "Increase tags by {C:attention}#2#{} when a {C:planet}Planet{} card is used",
            "At {C:attention}#3#{} tags, reset back to {C:attention}#4#{} and increase",
            "Chips and Mult per level on all hands by {C:attention}X#5#{}",
        }
    },
    valk_artist = "Pangaea",
    config = { extra = { tags = 2, tags_base = 2, inc = 1, max = 5, mult = 5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_meteor
        return { vars = { card.ability.extra.tags, card.ability.extra.inc, card.ability.extra.max, card.ability.extra.tags_base, card.ability.extra.mult } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = { x = 6, y = 12 },
    soul_pos = { x = 6, y = 13, extra = { x = 6, y = 14 } },
    cost = 35,
    immutable = true,
    calculate = function(self, card, context)
        if context.skip_blind then
            for i = 1, card.ability.extra.tags do
                add_tag(Tag("tag_meteor"))
            end
        end

        if context.using_consumeable and context.consumeable and context.consumeable.config.center.set == "Planet" then
            card.ability.extra.tags = card.ability.extra.tags + card.ability.extra.inc
            quick_card_speak(card, localize("k_upgrade_ex"))
            if card.ability.extra.tags > card.ability.extra.max then
                card.ability.extra.tags = card.ability.extra.tags_base
                quick_card_speak(card, localize("k_reset"))
                for name, _ in pairs(G.GAME.hands) do
                    G.GAME.hands[name].l_chips = G.GAME.hands[name].l_chips * card.ability.extra.mult
                    G.GAME.hands[name].l_mult = G.GAME.hands[name].l_mult * card.ability.extra.mult
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "phylactequila",
    loc_txt = {
        name = "Phylactequila",
        text = {
            "Create a {C:spectral}Spectral{} card when any other {C:attention}Consumable{} is used",
            "Fill empty {C:attention}Consumable{} slots with random {C:planet}Planet{} cards if",
            "played {C:attention}poker hand{} is a {C:attention}#1#{}",
            "{C:inactive}(Poker Hand changes at end of round)",
        }
    },
    valk_artist = "Pangaea",
    config = { extra = { hand = "Four of a Kind" } },
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.hand, "poker_hands") } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = { x = 7, y = 12 },
    soul_pos = { x = 7, y = 13, extra = { x = 7, y = 14 } },
    cost = 35,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.hand then
            for i = 1, (G.consumeables.config.card_limit - G.consumeables.config.card_count) do
                local c = SMODS.add_card({ set = "Planet", area = G.consumeables })
                quick_card_speak(card, localize("k_plus_planet"))
            end
        end

        if context.using_consumeable and context.consumeable.config.center.set ~= "Spectral" then
            SMODS.add_card({ set = "Spectral", area = G.consumeables })
            quick_card_speak(card, localize("k_plus_spectral"))
        end

        if context.end_of_round and context.main_eval then
            card.ability.extra.hand = pseudorandom_element(G.handlist, "valk_phylactequila")
        end
    end,

}

SMODS.Joker {
    key = "talas",
    pronouns = "he_him",
    loc_txt = {
        name = "TALAS",
        text = {
            "{C:attention}+#1#{} Shop Voucher slots",
            "Redeem {C:attention}#2#{} extra copies of all bought {C:attention}Vouchers{}",
        }
    },
    valk_artist = "Grahkon",
    atlas = "atlas2",
    pos = { x = 0, y = 7 },
    soul_pos = { extra = { x = 1, y = 7 }, x = 2, y = 7 },
    cost = 35,
    rarity = "valk_exquisite",
    config = { extra = { slots = 2, extra_vouchers = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.extra.extra_vouchers } }
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(card.ability.extra.slots)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(-card.ability.extra.slots)
    end,
    calculate = function(self, card, context)
        if context.buying_card and context.card.config.center.set == "Voucher" and not context.card.talas_flag then
            for i = 1, card.ability.extra.extra_vouchers do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local old_state = G.STATE
                        local voucher = SMODS.create_card({ key = context.card.config.center_key })
                        voucher.talas_flag = true
                        voucher:start_materialize()
                        G.play:emplace(voucher)
                        voucher.cost = 0
                        voucher.shop_voucher = false
                        local current_round_voucher = G.GAME.current_round.voucher
                        voucher:redeem()
                        G.GAME.current_round.voucher = current_round_voucher
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0,
                            func = function()
                                voucher:start_dissolve()
                                G.STATE = old_state
                                return true
                            end,
                        }))

                        return true
                    end,
                }))
            end
        end
    end
}

local messages = {
    "???",
    "uhh..?",
    "wha..",
    "oh",
    "!!!",
    "..hi",
    "ehe",
    "hiiii",
    ">w<",
    ":3"
}

local quotes = {
    "i'm a real girl, right?",
    "oh. hi!",
    "you look familiar",
    "do you want me to meow?",
    "mrreow!",
    "i'm sorry",
    "wait, i'm kitty?",
    "so many other people...",
    "i feel overwhelmed",
    "we're friends, right?",
    "...",
    "wear my halo? no.",
    "is *this* your card?",
    "i'm not the strongest here, that's illena!",
    "i've killed!",
    "are you my therapist",
    "pet me i dare you",
    "i'm just a dumb little cat",
    "my real name is LΔʌvikα!",
    "this is divine!",
    "illena's my best friend break her heart i'll break your face",
    "are you having fun?",
    "...woof?",
    "ugh, how long was i out for?",
    "please be nice to me",
    "this place is pretty dense",
    "where are my meds",
    "if i take off my halo i'll die!",
    "smart thinking!",
    
    
}

SMODS.Joker {
    key = "lily",
    loc_txt = {
        name = "{E:valk_floaty}Lily Felli",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult for each Joker owned",
            "{C:attention}Lordly{} Edition is {C:attention}#3#{} times more common",
            "{C:attention}Kitty{} Jokers each give {X:chips,C:white}X#4#{} Chips",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
            "{C:enhanced,s:0.7,E:1,f:6}#5#",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { per = 2, rate = 15, xchips = 2 } },
    loc_vars = function(self, info_queue, card)
        local jkrs = G.jokers and G.jokers.config.card_count or 0
        info_queue[#info_queue + 1] = G.P_CENTERS.e_valk_lordly
        local chosen_quote = quotes[math.random(1,#quotes)]
        return {
            vars = {
                card.ability.extra.per,
                1 + (card.ability.extra.per * jkrs),
                card.ability.extra.rate,
                card.ability.extra.xchips,
                chosen_quote,
            }
        }
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    no_doe = true,
    cost = 500,
    demicoloncompat = true,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                emult = 1 + (card.ability.extra.per * #G.jokers.cards)
            }
        end

        if context.other_joker and context.other_joker:is_kitty() then
            return {
                xchips = card.ability.extra.xchips
            }
        end

        if context.amm_pet_card and card.ability.immutable.ready then
        -- if context.amm_pet_card then
            card.ability.immutable.ready = false
            quick_card_speak(card, messages[math.min(card.ability.immutable.love, 10)])
            card.ability.immutable.love = card.ability.immutable.love + 1
        end

        if context.end_of_round and context.main_eval and not card.ability.immutable.ready then
            card.ability.immutable.ready = true
        end
    end,
    has_halo = true,
    lore = {
        "Lily is a Fellinian Entropic Lord, this means",
        "she was exposed to a lot of entropy, and eventually mutating her.",
        "This allowed her to control entropy around her, similar to weak reality bending.",
        "",
        "As a person, Lily tries her best, but is inherently unstable mentally",
        "due to the effects of entropy on a person's mental health.",
        "",
        "Her entropic lord powers allow for heightened senses,",
        "so it doesn't affect her as much, but she can barely see!"
    },
    pronouns = "she_her",
    add_to_deck = function(self, card, from_debuff)
        card.ability.immutable = card.ability.immutable or {}
        card.ability.immutable.love = 1
        card.ability.immutable.ready = true
    end
}