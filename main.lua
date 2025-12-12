to_big = to_big or function(x) return x end
to_number = to_number or function(x) return x end
-- no more talisman requirement!

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
    post_trigger = true,
}

vallkarri = {} --readding this helps lsp
vallkarri = SMODS.current_mod
vallkarri_config = vallkarri.config
vallkarri.enabled = copy_table(vallkarri_config)

vallkarri.path = "" .. SMODS.current_mod.path

vallkarri.librat_vals = { red = 62, blue = 61 }
vallkarri.last_message =
"Dear player. Please make sure to drink water and get eight hours of sleep, its really important to me that you guys stay healthy and strong, - love vagabond"
vallkarri.splash_options = {
    Entropy and "Also try Entro- oh, you already are" or "Also try Entropy!",
    "This is so VallKarric!",
    "meow!",
    "VallKarri Yeah!",
    "Now with 50% more cats!",
    "Play the game.",
    "Tell your friends!",
    "ahahaha it would be really funny if i just had an extremely long splash text that went off the screen wouldn't it??????? laugh at my joke you fucking loser i swear to god",
    "RIP Quilla",
    "+4 Zulu",
    "Not very Oblivious!",
    "i  s e e  y o u ",
    "made by a real girl!",
    "Includes 1 or 2 cats!"
}

vallkarri.credited_artists = {}
function vallkarri.choose_main_menu_text()
    return vallkarri.splash_options[math.random(1, #vallkarri.splash_options)]
end

function vallkarri.add_splash_text(text_or_table)
    if type(text_or_table) == "string" then
        vallkarri.splash_options[#vallkarri.splash_options + 1] = text_or_table
    end

    if type(text_or_table) == "table" then
        for _, text in pairs(text_or_table) do
            vallkarri.splash_options[#vallkarri.splash_options + 1] = text
        end
    end
end

SMODS.Atlas {
    key = "main",
    path = "assets.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "atlas2",
    path = "atlas_two.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "phold",
    path = "placeholder.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "modicon",
    path = "valk_icon.png",
    px = 34,
    py = 34,
}:register()

merge_recipes = {

}

assert(SMODS.load_file("loadfiles.lua", "vallkarri"))()
if Cryptid.pointerblistifytype then
    Cryptid.pointerblistifytype("rarity", "valk_selfinsert", nil)
    Cryptid.pointerblistifytype("rarity", "valk_quillagod", nil)
    Cryptid.pointerblistifytype("rarity", "valk_unsurpassed", nil)
    Cryptid.pointerblistifytype("rarity", "valk_prestigious", nil)
    Cryptid.pointerblistifytype("rarity", "valk_exquisite", nil)
    Cryptid.pointerblistify("v_valk_alphaboosterator", nil)
    Cryptid.pointerblistify("v_valk_betaboosterator", nil)
    Cryptid.pointerblistify("v_valk_gammaboosterator", nil)
    Cryptid.pointerblistify("c_valk_freeway", nil)
end

if Entropy then
    Entropy.ChaosBlacklist.Superplanet = true
end
Cryptid.mod_whitelist["Vall-karri"] = true


SMODS.current_mod.extra_tabs = function()
    return {
        {
            label = "Credits",
            tab_definition_function = vallkarri.credits_ui_def
        },
        {
            label = "Recommended Mods",
            tab_definition_function = vallkarri.recomm_ui_def
        }
    }
end

local function is_legal(str)
    -- must NOT start with .
    -- must NOT end with .png
    -- must NOT end with .pdn
    -- must NOT end with .ogg
    if (not string.find(str, "^%.")) and
        (not string.find(str, "%.png$")) and
        (not string.find(str, "%.pdn$")) and
        (not string.find(str, "%.ogg$")) then
        return true
    end
    return false
end

function vallkarri.recursive_concat_directory(path)
    local read = NFS.read(path)
    if read then
        return read
    else
        if (not string.find(path, "/$")) and (not string.find(path, "\\$")) then
            path = path .. "/"
        end

        local str = ""
        for _, entry in pairs(NFS.getDirectoryItems(path)) do
            if is_legal(entry) then
                local res = vallkarri.recursive_concat_directory(path .. entry)
                str = str .. tostring(res)
                -- print(path .. entry)
                -- print(#tostring(res))
            end
        end
        -- may need results in the future, not right now
        return str
    end
end

-- local hash_thread = love.thread.newThread(NFS.read(vallkarri.path .. "sha1.lua"))
-- local res = vallkarri.recursive_concat_directory(vallkarri.path)
-- hash_thread:start(res)

if string.find(vallkarri.version, "d") then
    vallkarri.debug_info = vallkarri.debug_info or {}
    vallkarri.debug_info.OMEGA_WARNING = "\nYOU ARE ON A DEVELOPMENT VERSION OF VALLKARRI\n\nIF YOU DO NOT KNOW WHAT YOU ARE DOING, INSTALL THE LATEST RELEASE\n"
end
