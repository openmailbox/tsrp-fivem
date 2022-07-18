local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    TriggerServerEvent(Events.GET_STASHES)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Stash.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
