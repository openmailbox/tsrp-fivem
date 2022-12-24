local function create(data)
    local player_id = source

    -- TODO: Validate

    TriggerClientEvent(Events.UPDATE_CHARACTER_NAME_VALIDATION, player_id, {
        first   = true,
        last    = true,
        success = true
    })
end
RegisterNetEvent(Events.CREATE_CHARACTER_NAME_VALIDATION, create)
