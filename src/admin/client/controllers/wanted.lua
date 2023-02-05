local function flush(data)
    Citizen.Wait(data.ping + 100)
    SetPlayerWantedLevelNow(PlayerId(), true)
end
RegisterNetEvent(Events.FLUSH_WANTED_STATUS, flush)
