local function show(_, cb)
    cb({
        hours   = GetClockHours(),
        minutes = GetClockMinutes()
    })
end
RegisterNUICallback(Events.GET_PHONE_GAME_TIME, show)
