local function create(data)
    if not NetworkDoesNetworkIdExist(data.target_net_id) then return end
    if not NetworkHasControlOfNetworkId(data.target_net_id) then return end

    local entity = NetToPed(data.target_net_id)
    if not DoesEntityExist(entity) then return end

    HostageDirector.add_hostage({
        ped     = entity,
        enactor = NetToPed(data.enactor_net_id)
    })
end
RegisterNetEvent(Events.CREATE_NEW_HOSTAGE, create)
