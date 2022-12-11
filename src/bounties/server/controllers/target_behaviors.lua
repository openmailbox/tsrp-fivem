local function create(data)
    local entity = NetworkGetEntityFromNetworkId(data.net_id)
    local owner  = NetworkGetEntityOwner(entity)

    TriggerClientEvent(Events.CREATE_BOUNTY_TARGET_BEHAVIOR, owner, {
        net_id        = data.net_id,
        source_net_id = data.my_net_id,
        behavior      = data.behavior
    })
end
RegisterNetEvent(Events.CREATE_BOUNTY_TARGET_BEHAVIOR, create)
