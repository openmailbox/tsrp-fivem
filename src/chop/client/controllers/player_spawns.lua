local function create(_)
    Hayes.reset()
    VehicleDropoff.cleanup()
    Radar.deactivate()
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
