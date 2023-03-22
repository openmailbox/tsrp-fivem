local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Zone.setup()
    TriggerServerEvent(Events.GET_ZONES)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
