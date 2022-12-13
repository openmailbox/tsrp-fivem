local function on_event(name, args)
    if name ~= Events.CLIENT_ENTITY_DAMAGE then return end

    local victim = args[1]
    local me     = PlayerPedId()

    if victim == me and GetEntityHealth(me) < GetEntityMaxHealth(me) then
        Map.reveal_objects()
    end
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
