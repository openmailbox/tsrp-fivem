local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/sentence", "Put a player in prison.", {
        { name = "target", help = "player ID of the target" }
    })
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
