local function create(data)
    local player_id = source
    local success   = true
    local message   = nil

    if data.dropoff.model ~= data.vehicle.model and data.dropoff.name ~= data.vehicle.name then
        success = false
        message = "Wrong vehicle type. Wanted: " .. data.dropoff.name .. ". Submitted: " .. data.vehicle.name .. "."
    end

    TriggerClientEvent(Events.UPDATE_CHOP_VEHICLE_DROPOFF, player_id, {
        success = success,
        message = message
    })

    if not success then return end

    DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(player_id)))
    exports.wallet:AdjustCash(player_id, 2500)
end
RegisterNetEvent(Events.CREATE_CHOP_VEHICLE_DROPOFF, create)
