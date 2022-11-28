local function update(_)
    VehicleDropoff.cleanup()
    Hayes.reset()
end
RegisterNetEvent(Events.UPDATE_CHOP_VEHICLE_DROPOFF, update)
