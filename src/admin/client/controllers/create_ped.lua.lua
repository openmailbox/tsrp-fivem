local function create(data)
    local ped  = PlayerPedId()
    local hash = GetHashKey(data.args[1])

    if not IsModelValid(hash) then
        TriggerEvent(Events.ADD_CHAT_MESSAGE, {
            color     = Colors.RED,
            multiline = true,
            args      = { GetCurrentResourceName(), "Invalid model '" .. data.args[1] .. "'." }
        })
        return
    end

    if not HasModelLoaded(hash) then
        RequestModel(hash)
    end

    data.location = GetEntityCoords(ped) + GetEntityForwardVector(ped)

    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

    TriggerServerEvent(Events.UPDATE_PED_SPAWN, data)
end
RegisterNetEvent(Events.CREATE_PED_SPAWN, create)

local function update(data)
    if not NetworkDoesEntityExistWithNetworkId(data.net_id) then return end
    local entity = NetToPed(data.net_id)
    SetModelAsNoLongerNeeded(GetEntityModel(entity))
end
RegisterNetEvent(Events.UPDATE_PED_SPAWN, update)
