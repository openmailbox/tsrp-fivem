local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/createo", "Spawn an object from a model.", {
        { name = "model", help = "model name for the object" }
    })

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/goto", "Go to specific map coordinates.", {
        { name = "x", help = "x-coordinate" },
        { name = "y", help = "y-coordinate" },
        { name = "z", help = "z-coordinate" }
    })

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/join", "Go to a player.", {
        { name = "player ID", help = "target player" }
    })
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    TriggerEvent(Events.REMOVE_CHAT_SUGGESTION, "/createo")
    TriggerEvent(Events.REMOVE_CHAT_SUGGESTION, "/goto")
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
