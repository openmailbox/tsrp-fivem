local function index()
    TriggerClientEvent(Events.UPDATE_ZONES, source, {
        zones = Zone.all()
    })
end
RegisterNetEvent(Events.GET_ZONES, index)
