local function index()
    TriggerClientEvent(Events.UPDATE_STASHES, source, {
        stashes = Stash.all()
    })
end
RegisterNetEvent(Events.GET_STASHES, index)
