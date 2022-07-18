local function update(data)
    if not data.stashes then return end
    Stash.cleanup()
    Stash.initialize(data.stashes)
end
RegisterNetEvent(Events.UPDATE_STASHES, update)
