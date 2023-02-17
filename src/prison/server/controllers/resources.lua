local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
end
AddEventHandler(Events.ON_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
