local function on_event(name, args)
    if name ~= Events.CLIENT_PLAYER_COLLECT_AMBIENT_PICKUP then return end

    if args[1] ~= Objects.CASH_PICKUP then return end

    TriggerServerEvent(Events.CREATE_CASH_PICKUP, {
        amount = args[2]
    })
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
