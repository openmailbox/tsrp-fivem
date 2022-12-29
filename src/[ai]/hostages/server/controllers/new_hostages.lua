local function create(data)
    local player_id = source
    local entity    = NetworkGetEntityFromNetworkId(data.target_net_id)

    if not DoesEntityExist(entity) then return end

    HostageDirector.add_hostage({
        entity  = entity,
        net_id  = data.target_net_id,
        enactor = player_id
    })
end
RegisterNetEvent(Events.CREATE_NEW_HOSTAGE, create)
