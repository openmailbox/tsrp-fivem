local function update(data)
    local enactor = source
    local x, y, z = table.unpack(data.location)
    local hash    = GetHashKey(data.args[1])
    local timeout = GetGameTimer() + 5000

    local object  = CreateObject(hash, x, y, z, true, false, false)
    local message = "Created object " .. object .. " from " .. data.args[1] .. " (" .. hash .. ") at " .. data.location .. "."

    while not DoesEntityExist(object) and GetGameTimer() < timeout do
        Citizen.Wait(5)
    end

    if not DoesEntityExist(object) then
        TellPlayer(enactor, "Unable to spawn object.")
        return
    end

    TriggerClientEvent(Events.UPDATE_OBJECT_SPAWN, enactor, {
        net_id = NetworkGetNetworkIdFromEntity(object)
    })

    TellPlayer(enactor, message)
    Citizen.Trace("Player " .. enactor .. " (" .. GetPlayerName(enactor) .. ") " .. string.lower(message) .. "\n")
end
RegisterNetEvent(Events.UPDATE_OBJECT_SPAWN, update)
