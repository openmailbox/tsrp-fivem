local function create(data)
    local ped  = PlayerPedId()
    local hash = GetHashKey(data.args[1])

    if not HasModelLoaded(hash) then
        RequestModel(hash)
    end

    data.location = GetEntityCoords(ped) + GetEntityForwardVector(ped)

    TriggerServerEvent(Events.UPDATE_OBJECT_SPAWN, data)
end
RegisterNetEvent(Events.CREATE_OBJECT_SPAWN, create)
