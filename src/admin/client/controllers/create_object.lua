local function create(data)
    local ped  = PlayerPedId()
    local hash = GetHashKey(data.args[1])

    if not HasModelLoaded(hash) then
        RequestModel(hash)
    end

    data.location = GetEntityCoords(ped) + GetEntityForwardVector(ped)

    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

    TriggerServerEvent(Events.UPDATE_OBJECT_SPAWN, data)
end
RegisterNetEvent(Events.CREATE_OBJECT_SPAWN, create)

local function update(data)
    local entity = NetToObj(data.net_id)

    ActivatePhysics(entity)
    SetModelAsNoLongerNeeded(GetEntityModel(entity))
end
RegisterNetEvent(Events.UPDATE_OBJECT_SPAWN, update)
