local function update(_)
    VehicleDropoff.cleanup()
    Hayes.reset()
    Radar.deactivate()
    VehicleSpawn.cleanup()
end
RegisterNetEvent(Events.UPDATE_CHOP_VEHICLE_DROPOFF, update)
