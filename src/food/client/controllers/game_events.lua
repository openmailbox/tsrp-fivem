local is_active = false

local function on_event(name, args)
    if name ~= Events.CLIENT_ENTITY_DAMAGE then return end
    if is_active then return end

    local victim = args[1]
    local me     = PlayerPedId()

    if victim ~= me or GetEntityHealth(me) >= GetEntityMaxHealth(me) then
        return
    end

    is_active = true

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Revealing world objects that restore health."
    })

    Trash.initialize()

    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local max = GetEntityMaxHealth(ped)

        while is_active do
            if ped ~= PlayerPedId() or IsPedDeadOrDying(ped, 1) or GetEntityHealth(ped) >= max then
                is_active = false
            end

            Citizen.Wait(3000)
        end

        Trash.cleanup()

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Hiding world objects that restore health."
        })
    end)
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
