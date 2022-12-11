local function create(data)
    if data.behavior == Target.Behaviors.FLEEING then
        local victim = NetToPed(data.net_id)
        local source = NetToPed(data.source_net_id)

        TaskSmartFleePed(victim, source, 500.0, -1)
    else
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Unrecognized target behavior: '" .. tostring(data.behavior) .. "'."
        })
    end
end
RegisterNetEvent(Events.CREATE_BOUNTY_TARGET_BEHAVIOR, create)
