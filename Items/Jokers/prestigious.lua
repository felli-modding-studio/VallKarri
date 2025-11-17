SMODS.Rarity {
    key = 'prestigious',
    loc_txt = {
        name = 'Prestigious'
    },
    badge_colour = G.C.VALK_PRESTIGIOUS,
    pools = { ["Joker"] = false },
}

SMODS.Joker {
    key = "vallkarrilua",
    loc_txt = {
        name = "{C:valk_blue}Vall-Karri.lua",
        text = {
            "{X:dark_edition,C:white}^^#1#{} Mult for every piece of {C:attention}content",
            "that {B:1,E:2,C:white}Vall-karri{} adds",
            "{C:inactive}(Currently {X:dark_edition,C:white}^^#2#{C:inactive} Mult){}",
            quote("valklua"),
        }
    },
    valk_artist = "Grahkon",
    config = { extra = { mult = 0.01 } },
    loc_vars = function(self, info_queue, card)
        local total = valk_additions()
        return { vars = { card.ability.extra.mult, total * card.ability.extra.mult, colours = { HEX("e5bf3a") } } }
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = { x = 8, y = 11 },
    soul_pos = { extra = { x = 9, y = 11 }, x = 10, y = 11 },
    cost = 500,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                ee_mult = valk_additions() * card.ability.extra.mult
            }
        end
    end,
    lore = {
        "thank you for playing my mod",
        "and thank you even more, for choosing to read the lore section.",
        "",
        "i never expected vallkarri to become popular",
        "nor did i expect to be able to handle the pressure",
        "but i am! (i think..)",
        "",
        "it means a lot to me, every individual player.",
        "truly, every time i see someone using vallkarri randomly,",
        "i feel so happy knowing i chose to keep making this",
        "",
        "whenever i create something, which is already rare",
        "i never really expect my creations to become anything",
        "and vallkarri is no exception",
        "",
        "it started as a simple overscoring mod called AnteShredder, (dumb name, yeah) nothing crazy.",
        "just made to balance out mods that had insane scoring, to make the game less meaningless",
        "but as time went on, i realized i wanted to make something",
        "so i started adding real content to it",
        "",
        "as it evolved, i realized this is what i wanted to keep doing in my free time",
        "i kept adding and adding, eventually reaching something like what we have today,",
        "and i can't be happier with how it's ended up so far",
        "",
        "my last main thing to say, thank you all for sticking through when the mod felt dead.",
        "i heavily lost motivation for some time, and really was not in a great place mentally",
        "and i was honestly planning on abandoning the mod, but i didn't",
        "i kept going, and i knew immediately it was the right choice.",
        "",
        "special thank-you to: Scraptake, Pangaea, and Mailingway/Patchy. This mod would be nowhere without you",
        "-lily <3",
        "note: i can't stop you but, please don't share this via image/text.",
        "i'd like each person to find it themselves."
    }
}

SMODS.Joker {
    key = "phicer",
    loc_txt = {
        name = "Phicer Rekiniov",
        text = {
            "Create a random {C:attention}perishable{} ",
            "{C:valk_exquisite}Exquisite{} Joker at end of round",
            quote("phicer"),
        }
    },
    valk_artist = "Nerxiana",
    config = { extra = { nchips = 2 } },
    rarity = "valk_prestigious",
    atlas = "main",
    pos = { x = 2, y = 13 },
    soul_pos = { x = 3, y = 13 },
    cost = 500,
    demicoloncompat = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local exq = SMODS.create_card({rarity = "valk_exquisite"})
            exq:set_perishable(true)
        end
    end,

    lore = {
        "Phicer Rekiniov is a magical casino owner, who's",
        "garnered a somewhat cult-like following over time.",
        "",
        "She is capable of doing highly-complex magic, but prefers to",
        "use simpler magic for things like summoning workers.",
        "",
        "Though, if needed she can summon weaker versions of",
        "monsters like dragons, wyrms or angel-like entities."
    }
}

SMODS.Atlas {
    key = "triangle",
    path = "triangle_walk_lowered.png",
    px = 71,
    py = 95,
}

SMODS.Joker {
    dependencies = { "MoreFluff" },
    key = "triangle",
    loc_txt = {
        name = "Triangle",
        text = {
            "When {C:attention}Blind{} selected, create {C:attention}#1#{} {C:dark_edition}Negative{} {C:colourcard}Colour{} cards",
            "All {C:colourcard}Colour{} cards gain {C:attention}+#2#{} rounds when {C:attention}3{} scored",
        }
    },
    valk_artist = "notmario",
    config = { extra = { rounds = 3, cards = 3 }, immutable = { buffer = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards, card.ability.extra.rounds } }
    end,
    rarity = "valk_prestigious",
    atlas = "triangle",
    pos = { x = 12, y = 4 },
    soul_pos = { x = 0, y = 0 },
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if context.setting_blind then
            for i = 1, card.ability.extra.cards do
                local colour = create_card("Colour", G.consumeables, nil, nil, nil, nil, nil, "valk_triangle")
                colour:add_to_deck()
                colour:set_edition("e_negative")
                G.consumeables:emplace(colour)
            end
        end

        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 3 then
            for i = 1, card.ability.extra.rounds do
                colour_end_of_round_effects()
            end
        end
    end,

    update = function(self, card, front)
        card.ability.immutable.buffer = card.ability.immutable.buffer + 1
        if card.ability.immutable.buffer >= 2 then
            card.ability.immutable.buffer = 0
            local pos = card.children.floating_sprite.sprite_pos
            local new = { x = pos.x + 1, y = pos.y }
            if new.x > 12 then
                new.x = 0
                new.y = new.y + 1
            end
            if new.x >= 12 and new.y >= 4 then
                new.x = 0
                new.y = 0
            end
            -- print(new)

            card.children.floating_sprite:set_sprite_pos(new)
        end
    end,
    pronouns = "she_they",
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
    "my real name is LΔʌvikα!"
}

SMODS.Joker {
    key = "lily",
    loc_txt = {
        name = "{E:valk_floaty}Lily Felli",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult for each Joker owned",
            "{C:attention}Lordly{} Edition is {C:attention}#3#{} times more common",
            "{C:attention}Kitty{} Jokers each give {X:dark_edition,C:white}^#4#{} Chips",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
            "{C:enhanced,s:0.7,E:1,f:6}#5#",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { per = 2, rate = 50, echip = 1.15 } },
    loc_vars = function(self, info_queue, card)
        local jkrs = G.jokers and #G.jokers.cards or 0
        info_queue[#info_queue + 1] = G.P_CENTERS.e_valk_lordly
        local chosen_quote = quotes[math.random(1,#quotes)]
        return {
            vars = {
                card.ability.extra.per,
                1 + (card.ability.extra.per * jkrs),
                card.ability.extra.rate,
                card.ability.extra.echip,
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
                echips = card.ability.extra.echip
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
