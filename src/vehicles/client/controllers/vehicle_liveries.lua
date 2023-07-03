-- Forward delcarations
local chat

local function update(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if not data.value then
        chat("This vehicle has " .. GetVehicleLiveryCount(vehicle) .. " liveries.")
        return
    end

    SetVehicleLivery(vehicle, tonumber(data.value))
end
RegisterNetEvent(Events.UPDATE_VEHICLE_LIVERY, update)

-- @local
function chat(message)
    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), message }
    })
end
