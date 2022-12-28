local function create(data)
    local player_id = source
    local entity    = NetworkGetEntityFromNetworkId(data.target_net_id)
    local owner     = NetworkGetEntityOwner(entity)

    TriggerClientEvent(Events.CREATE_NEW_HOSTAGE, owner, {
        target_net_id  = data.target_net_id,
        enactor_net_id = NetworkGetNetworkIdFromEntity(GetPlayerPed(player_id))
    })
end
RegisterNetEvent(Events.CREATE_NEW_HOSTAGE, create)
