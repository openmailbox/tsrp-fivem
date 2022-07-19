local function create(data)
    local stash = Stash.find_by_name(data.stash.name)
    if not stash then return end

    local player  = source
    local x, y, z = table.unpack(stash.location)
    local object  = CreateObject(stash.model, x, y, z, true, false, false)
    local timeout = GetGameTimer() + 3000

    while not DoesEntityExist(object) and GetGameTimer() < timeout do
        Citizen.Wait(10)
    end

    if DoesEntityExist(object) then
        Citizen.Trace("Spawned stash for '" .. stash.name .. "' at " .. stash.location .. ".\n")

        stash.object_id = object
        Entity(object).state.stash_name = stash.name

        TriggerClientEvent(Events.UPDATE_STASH_OBJECT, player, {
            net_id = NetworkGetNetworkIdFromEntity(stash.object_id)
        })
    end
end
RegisterNetEvent(Events.CREATE_STASH_OBJECT, create)
