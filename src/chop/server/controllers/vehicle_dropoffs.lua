local function create(data)
    local player_id = source

    if data.dropoff.model ~= data.vehicle.model and data.dropoff.name ~= data.vehicle.name then
        TriggerClientEvent(Events.ADD_CHAT_MESSAGE, player_id, {
            color     = Colors.RED,
            multiline = true,
            args      = { "GAME", "Wrong vehicle type. Wanted: " .. data.dropoff.name .. ". Submitted: " .. data.vehicle.name .. "." }
        })

        return
    end

    exports.wallet:AdjustCash(player_id, 2500)

    DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(player_id)))
    TriggerClientEvent(Events.UPDATE_CHOP_VEHICLE_DROPOFF, player_id)
end
RegisterNetEvent(Events.CREATE_CHOP_VEHICLE_DROPOFF, create)
