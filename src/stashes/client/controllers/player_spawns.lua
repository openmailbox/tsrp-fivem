local function create(_)
    Stash.close_all()
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
