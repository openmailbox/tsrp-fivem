local function create(data)
    local event = Event.find_by_id(data.event.id)
    if not event then return end

    local player  = source
    local x, y, z = table.unpack(event.location)
    local object  = CreateObject(data.model, x, y, z, true, false, false)
    local timeout = GetGameTimer() + 3000

    while not DoesEntityExist(object) and GetGameTimer() < timeout do
        Citizen.Wait(10)
    end

    if DoesEntityExist(object) then
        Citizen.Trace("Spawned stash for Event " .. event.id .. " at " .. event.location .. ".\n")

        event.stash = object

        TriggerClientEvent(Events.UPDATE_STASH_OBJECT, player, {
            net_id = NetworkGetNetworkIdFromEntity(event.stash)
        })
    end
end
RegisterNetEvent(Events.CREATE_STASH_OBJECT, create)
