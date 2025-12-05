local colours = {
    code = HEX("FCA0FF"),
    art = HEX("A0CCFF"),
    shader = HEX("93D191")
}
local text_scale = 0.30
local scale = 0.5
function vallkarri.credits_ui_def()
    local ui = {
        n = G.UIT.ROOT,
        config = { align = "cm", minh = G.ROOM.T.h * scale, minw = G.ROOM.T.w * scale, padding = 0.0, r = 0.1, colour = G.C.GREY },
        nodes = {
            {
                n = G.UIT.R,
                config = {},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cl", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Programming", colour = colours.code, scale = text_scale * 2, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Lily Felli", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "InvalidOS", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "cg223", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "wingedcatgirl", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "baccon3", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } } } },
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cm", minw = 3, padding = 0.1 },
                        nodes = vallkarri.artist_credit_ui()
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cr", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Misc", colour = colours.shader, scale = text_scale * 2, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Lily Felli - Shaders", colour = colours.shader, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Pangaea - SFX", colour = colours.shader, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "MVBit - SFX", colour = colours.shader, scale = text_scale, shadow = true, align = "tm" } } } },
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "gudusername - Deck Skin", colour = colours.shader, scale = text_scale, shadow = true, align = "tm" } } } },
                        }
                    },
                }
            }

        }
    }

    return ui
end

function vallkarri.artist_credit_ui()
    local built = {
        { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Artists", colour = colours.art, scale = text_scale * 2, shadow = true, align = "tm" } } } },
    }
    vallkarri.refresh_artist_credit_buttons()
    for artist, _ in pairs(vallkarri.credited_artists) do
        table.insert(built,
            {
                n = G.UIT.R,
                config = {},
                nodes = { {
                    n = G.UIT.C,
                    config = { button = "vallkarri_artist_" .. artist, colour = G.C.UI.OUTLINE_DARK, minh = 0.3, minw = 2, r = 0.05, align = "tm" },
                    nodes = {
                        { n = G.UIT.T, config = { text = artist, colour = G.C.UI.TEXT_LIGHT, scale = text_scale * 0.85, shadow = true } }
                    }
                } }
            }
        )
    end

    return built
end

function vallkarri.refresh_artist_credit_buttons()
    for artist, credited_cards in pairs(vallkarri.credited_artists) do
        G.FUNCS["vallkarri_artist_" .. artist] = function(e)
                
            local cards_with_art = {}
            for _, card in pairs(credited_cards) do
                table.insert(cards_with_art, SMODS.Center.obj_table[card])
            end
            G.SETTINGS.paused = true
            G.FUNCS.overlay_menu {
                definition = SMODS.card_collection_UIBox(cards_with_art, { 5, 5, 5 }),
            }
        end
    end
end

-- return vallkarri.credits_ui_def()
