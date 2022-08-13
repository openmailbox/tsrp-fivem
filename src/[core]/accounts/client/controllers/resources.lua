local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    TriggerServerEvent(Events.CREATE_ACCOUNT_SESSION)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
