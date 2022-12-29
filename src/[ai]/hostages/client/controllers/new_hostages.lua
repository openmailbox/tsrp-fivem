local function create(data)
    if not NetworkDoesNetworkIdExist(data.net_id) then return end
    if not NetworkHasControlOfNetworkId(data.net_id) then return end

    local entity = NetToPed(data.net_id)
    if not DoesEntityExist(entity) then return end

    SetBlockingOfNonTemporaryEvents(entity, true)
    TaskSetBlockingOfNonTemporaryEvents(entity, true)
end
RegisterNetEvent(Events.CREATE_NEW_HOSTAGE, create)

local function delete(data)
    if not NetworkDoesNetworkIdExist(data.net_id) then return end
    if not NetworkHasControlOfNetworkId(data.net_id) then return end

    local entity = NetToPed(data.net_id)
    if not DoesEntityExist(entity) then return end

    SetBlockingOfNonTemporaryEvents(entity, false)
    TaskSetBlockingOfNonTemporaryEvents(entity, false)
end
RegisterNetEvent(Events.DELETE_NEW_HOSTAGE, delete)
