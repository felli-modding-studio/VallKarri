local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)
    G.GAME.run_ante_modifiers = G.GAME.run_ante_modifiers or {}

    if args.savetext then
        return
    end

    G.GAME.run_ante_modifiers = {}

    if not G.GAME.vallkarri then
        G.GAME.vallkarri = {}
        G.GAME.vallkarri.spawn_multipliers = {}
        G.GAME.vallkarri.banned_use_keys = {}
        for key, _ in pairs(G.P_CENTERS) do
            G.GAME.vallkarri.spawn_multipliers[key] = 1
            G.GAME.vallkarri.banned_use_keys[key] = false
        end
    end

    if not G.GAME.ante_config and config_reset then
        config_reset()
    end


    for name, center in pairs(G.P_CENTERS) do
        if center.old_weight then
            G.P_CENTERS[name].weight = center.old_weight
        end
    end

    G.jokers.config.highlighted_limit = 1e10 -- bleehhhhhh
end