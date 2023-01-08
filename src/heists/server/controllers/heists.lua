local function index()
    local player_id = source

    -- Should only happen during a resource restart with connected players
    if not HeistLocations.ready then
        repeat
            Citizen.Wait(20)
        until HeistLocations.ready
    end

    TriggerClientEvent(Events.UPDATE_HEISTS, player_id, {
        heists = Heist.all()
    })
end
RegisterNetEvent(Events.GET_HEISTS, index)
