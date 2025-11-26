vallkarri.config_tab = function() -- the configs will be stored in config.lua and you can find the file of the configs in "Roaming/balatro/config" then vallkarri.jkr for this mod
    local scale = 5 / 6
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", minh = G.ROOM.T.h * 0.25, padding = 0.0, r = 0.1, colour = G.C.GREY },
        nodes = {
            {
                n = G.UIT.C,
                config = { padding = 0.05 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Enable Overscoring",                                                                                -- the label that shows up next to the toggle button
                                info = { "Overscoring is a mechanic which increases your ante", "if you score too high on the boss blind" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                                                   -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                                                -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "overscoring"                                                                                    -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Toggle levelling",                                                                                                 -- the label that shows up next to the toggle button
                                info = { "Enables the levelling system", "Gives benefits, but increases blind size based on level", "(Requires restart)" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                                                                  -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                                                               -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "metaprogression"                                                                                               -- the value from the ref_table that the toggle will change when pressed
                            }
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Excessive badges",                                                            -- the label that shows up next to the toggle button
                                info = { "Add badges to certain cards which may be bothersome, but give extra info" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                             -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                          -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "excessive_badges"                                                         -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                }
            },
            {
                n = G.UIT.C,
                config = { padding = 0.05 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Enable hand buffs",                                         -- the label that shows up next to the toggle button
                                info = { "Bonuses if you play a hand of 5 identical enhancements" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                           -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                        -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "hand_buffs"                                             -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Enable HTTP connection",                                         -- the label that shows up next to the toggle button
                                info = { "Used for player counts, and some Jokers" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                           -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                        -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "http_allowed"                                             -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                },
            }

        }
    }
end
