local function index()
    TriggerClientEvent(Events.UPDATE_STASH_MODELS, source, {
        models = Stash.models()
    })
end
RegisterNetEvent(Events.GET_STASH_MODELS, index)
