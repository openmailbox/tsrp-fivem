local function update(_)
    VehicleDropoff.cleanup()
    Hayes.reset()
    Radar.deactivate()
end
RegisterNetEvent(Events.UPDATE_CHOP_VEHICLE_DROPOFF, update)
