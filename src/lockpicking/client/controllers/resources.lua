local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    TriggerEvent('chat:removeSuggestion', '/lockpick')
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
