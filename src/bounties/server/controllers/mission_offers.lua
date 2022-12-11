local function create(data)
    local player_id = source

    -- TODO: Generate something interesting about the mission
    data.success = true

    TriggerClientEvent(Events.UPDATE_BOUNTY_MISSION_OFFER, player_id, data)
end
RegisterNetEvent(Events.CREATE_BOUNTY_MISSION_OFFER, create)
