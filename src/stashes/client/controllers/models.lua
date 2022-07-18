local function update(data)
    Stash.cleanup()
    Stash.initialize(data.models)
end
RegisterNetEvent(Events.UPDATE_STASH_MODELS, update)
