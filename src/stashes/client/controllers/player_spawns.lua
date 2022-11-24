local function create(_)
    Stash.close_all()
    LestersHouse.reset()
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
