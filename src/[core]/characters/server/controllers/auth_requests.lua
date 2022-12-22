local function create(_)
    local player_id = source

    TriggerClientEvent(Events.UPDATE_CHARACTER_AUTH_REQUEST, player_id, {
        success = true
    })
end
RegisterNetEvent(Events.CREATE_CHARACTER_AUTH_REQUEST, create)
