local lc = loc_colour
local aes_colour = HEX("4500FF")
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        lc()
    end
    G.ARGS.LOC_COLOURS.valk_aesthetic = aes_colour
    return lc(_c, _default)
end

G.C.VALK_AESTHETIC = aes_colour

SMODS.Atlas {
    key = "aes",
    path = "aesthetic.png",
    px = 71,
    py = 95,
}

SMODS.ConsumableType {
    key = "Aesthetic",
    collection_rows = { 6, 6 },
    primary_colour = HEX("6A33FF"),
    secondary_colour = aes_colour,
    shop_rate = 0.4,

    loc_txt = {
        collection = "Aesthetic Cards",
        label = "aesthetic",
        name = "Aesthetic Cards",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
            }
        }
    },
}

local function key_to_name(str)
    str = str:gsub("__", ".")
    str = str:gsub("_", " ")
    str = str:gsub("(%a)([%w%.]*)", function(first, rest) return first:upper() .. rest end)
    return str
end

local aesthetic_cards = {

    { pos = { x = 0, y = 0 }, key = "e_foil", name = "frutiger_aero" },
    { pos = { x = 1, y = 0 }, key = "e_holo", name = "synthwave" },
    { pos = { x = 2, y = 0 }, key = "e_polychrome", name = "chromecore" },
    { pos = { x = 3, y = 0 }, key = "e_negative", name = "vaporwave" },
    { pos = { x = 0, y = 3 }, key = "e_valk_rgb", name = "scene!xD", artist = "Lil Mr. Slipstream" },
    { pos = { x = 1, y = 3 }, key = "e_valk_cosmic", name = "memphis", artist = "Lil Mr. Slipstream" },
    { pos = { x = 2, y = 3 }, key = "e_valk_glow", name = "arcadecore", artist = "Lil Mr. Slipstream" },
    { pos = { x = 3, y = 3 }, key = "e_valk_lordly", name = "savior", hidden = true, soul_rate = 5},
    { pos = { x = 0, y = 1 }, key = "e_cry_glitched", name = "glitch", dep = {"Cryptid"} },
    { pos = { x = 1, y = 1 }, key = "e_cry_mosaic", name = "antique", dep = {"Cryptid"} },
    { pos = { x = 2, y = 1 }, key = "e_cry_oversat", name = "weirdcore", dep = {"Cryptid"} },
    { pos = { x = 3, y = 1 }, key = "e_cry_glass", name = "net__art", dep = {"Cryptid"} },
    { pos = { x = 0, y = 2 }, key = "e_cry_gold", name = "vectorheart", dep = {"Cryptid"} },
    { pos = { x = 1, y = 2 }, key = "e_cry_blur", name = "liminality", dep = {"Cryptid"} },
    { pos = { x = 2, y = 2 }, key = "e_cry_noisy", name = "analog_horror", dep = {"Cryptid"} },
    { pos = { x = 3, y = 2 }, key = "e_cry_astral", name = "raygun_gothic", dep = {"Cryptid"} },
    { pos = { x = 4, y = 2 }, key = "e_cry_m", name = "metalheart", dep = {"Cryptid"} },
}

for _, edit in ipairs(aesthetic_cards) do
    SMODS.Consumable {
        set = "Aesthetic",
        key = edit.name,
        loc_txt = {
            name = key_to_name(edit.name),
            text = {
                "Enhance up to {C:attention}#1#{} selected",
                "Joker with {C:attention}#2#{}",
            }
        },
        valk_artist = edit.artist or "Pangaea",
        cost = 7,
        pos = edit.pos,
        atlas = "aes",
        config = { extra = { select = 1, edition = edit.key } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[edit.key]
            return { vars = { 
                card.ability.extra.select,
                localize({ type = "name_text", set = "Edition", key = card.ability.extra.edition })
            } }
        end,
        can_use = function(self, card)
            local highlighted = Cryptid.get_highlighted_cards({G.jokers}, card, 1, card.ability.extra.select, function(card) return not card.edition end)
            return (#highlighted > 0) and (#highlighted <= card.ability.extra.select)
        end,
        use = function(self, card, area, copier)
            for i, high in ipairs(Cryptid.get_highlighted_cards({G.jokers}, card, 1, card.ability.extra.select, function(card) return not card.edition end)) do
                high:set_edition(card.ability.extra.edition)
            end
        end,
        demicoloncompat = true,
        force_use = function(self, card)
            self:use(card)
        end,
        dependencies = edit.dep,
        hidden = edit.hidden,
        soul_rate = edit.rate,
        soul_set = edit.soul_set,

    }
end

SMODS.Consumable {
    set = "Spectral",
    key = "prune",
    loc_txt = {
        name = "Prune",
        text = {
            "{C:attention}Editions{} of all owned jokers are {C:red}banished{}",
            "{C:attention}Editions{} appear {C:attention}X#1#{} more often",
        }
    },
    pos = { x = 4, y = 0 },
    atlas = "aes",
    valk_artist = "Pangaea",
    config = { extra = { mult = 10 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    can_use = function(self, card)
        for i, jkr in ipairs(G.jokers.cards) do
            if jkr.edition then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        for i, joker in ipairs(G.jokers.cards) do
            if joker.edition then
                G.P_CENTERS[joker.edition.key].old_weight = G.P_CENTERS[joker.edition.key].weight
                G.P_CENTERS[joker.edition.key].weight = 0
                joker:set_edition("e_base")
            end
        end

        G.GAME.edition_rate = G.GAME.edition_rate * card.ability.extra.mult
    end,
    in_pool = function()
        for i, jkr in ipairs(G.jokers.cards) do
            if jkr.edition then
                return true
            end
        end
        return false
    end,
    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Spectral",
    key = "revitalism",
    loc_txt = {
        name = "Revitalism",
        text = {
            "Give all jokers a random {C:attention}Edition{}",
            "{C:attention}+#1#{} Effective Ante",
        }
    },
    pos = { x = 4, y = 1 },
    atlas = "aes",
    valk_artist = "Pangaea",
    config = { extra = { ante = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.ante } }
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        for i,joker in ipairs(G.jokers.cards) do
            joker:set_edition(poll_edition("valk_revitalism", 1, false, true))
        end
        vallkarri.add_effective_ante_mod(card.ability.extra.ante, "+")
    end,
    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}
