local count = 0

local function create(data)
    local player_id = source

    -- TODO: Generate something interesting about the mission
    count = count + 1

    data.success = true
    data.ping    = GetPlayerPing(player_id)
    data.id      = count

    TriggerClientEvent(Events.UPDATE_BOUNTY_MISSION_OFFER, player_id, data)
end
RegisterNetEvent(Events.CREATE_BOUNTY_MISSION_OFFER, create)
