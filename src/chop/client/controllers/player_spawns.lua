local function create(_)
    Hayes.reset()
    VehicleDropoff.cleanup()
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
