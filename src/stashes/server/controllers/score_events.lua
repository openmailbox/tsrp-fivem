local function create(data)
    Scoreboard.record(source, data.weapon, 1)
end
RegisterNetEvent(Events.CREATE_STASH_SCORE_EVENT, create)
