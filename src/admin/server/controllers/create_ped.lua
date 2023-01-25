local function update(data)
    local enactor = source
    local x, y, z = table.unpack(data.location)
    local hash    = GetHashKey(data.args[1])
    local timeout = GetGameTimer() + 5000

    local ped     = CreatePed(4, hash, x, y, z, 0, true, false)
    local message = "Created ped " .. ped .. " from " .. data.args[1] .. " (" .. hash .. ") at " .. data.location .. "."

    while not DoesEntityExist(ped) and GetGameTimer() < timeout do
        Citizen.Wait(5)
    end

    if not DoesEntityExist(ped) then
        TellPlayer(enactor, "Unable to spawn ped.")
        return
    end

    TriggerClientEvent(Events.UPDATE_PED_SPAWN, enactor, {
        net_id = NetworkGetNetworkIdFromEntity(ped)
    })

    TellPlayer(enactor, message)
    Citizen.Trace("Player " .. enactor .. " (" .. GetPlayerName(enactor) .. ") " .. string.lower(message) .. "\n")
end
RegisterNetEvent(Events.UPDATE_PED_SPAWN, update)
