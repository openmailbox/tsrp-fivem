local function on_event(name, args)
    if name ~= Events.CLIENT_ENTITY_DAMAGE then return end

    local victim  = args[1]
    local is_dead = args[6] == 1

    if is_dead and math.random() > 0.33 then
        TriggerEvent(Events.CREATE_CASH_PICKUP, {
            location = GetEntityCoords(victim),
            amount   = math.random(5, 100)
        })
    end
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
