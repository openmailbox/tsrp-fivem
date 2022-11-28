local function update(data)
    if not data.success then
        TriggerEvent(Events.ADD_CHAT_MESSAGE, {
            color     = Colors.RED,
            multiline = true,
            args      = { "GAME", data.message }
        })
        return
    end

    VehicleDropoff.cleanup()
    Hayes.reset()
end
RegisterNetEvent(Events.UPDATE_CHOP_VEHICLE_DROPOFF, update)
