local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Event.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
