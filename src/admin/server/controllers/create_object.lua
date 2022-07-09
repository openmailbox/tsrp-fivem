local function update(data)
    local enactor = source
    local x, y, z = table.unpack(data.location)
    local hash    = GetHashKey(data.args[1])

    local object  = CreateObject(hash, x, y, z, true, false, false)
    local message = "Created object " .. object .. " from " .. data.args[1] .. " (" .. hash .. ") at " .. data.location .. "."

    TellPlayer(enactor, message)
    Citizen.Trace("Player " .. enactor .. " (" .. GetPlayerName(enactor) .. ") " .. string.lower(message) .. "\n")
end
RegisterNetEvent(Events.UPDATE_OBJECT_SPAWN, update)
