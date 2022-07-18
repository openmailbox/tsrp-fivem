local function update(data)
    Stash.initialize(data.models)
end
RegisterNetEvent(Events.UPDATE_STASH_MODELS, update)
