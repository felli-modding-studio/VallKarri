VALK.LOADING = {objects = {}}

VALK.LOADING.load = function()
    for i, v in pairs(VALK.LOADING.objects) do
        table.sort(v, function(a, b) return (a.order or 0) < (b.order or 0) end)
    end
    for i, v in pairs(VALK.LOADING.objects) do
        for _, object in pairs(v) do
            SMODS[object.object_type](object)
        end
    end
end