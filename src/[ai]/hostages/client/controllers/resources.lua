local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    Following.initialize()

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/cuff", "Detain a player.", {
        { name = "target", help = "player ID of the target" }
    })

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/uncuff", "Release a detained player.", {
        { name = "target", help = "player ID of the target" }
    })
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Cuffs.cleanup()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
