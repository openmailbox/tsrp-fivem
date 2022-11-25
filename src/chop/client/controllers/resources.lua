local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Hayes.initialize()
    Hayes.reset()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Hayes.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
