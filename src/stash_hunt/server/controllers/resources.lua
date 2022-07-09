local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Event.check_and_init()
end
AddEventHandler(Events.ON_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Event.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
