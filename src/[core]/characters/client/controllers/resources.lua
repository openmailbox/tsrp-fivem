local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    TriggerEvent(Events.CREATE_CHARACTER_SELECT_SESSION)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
