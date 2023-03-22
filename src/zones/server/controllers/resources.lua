local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Zone.setup()
end
AddEventHandler(Events.ON_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Zone.teardown()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
