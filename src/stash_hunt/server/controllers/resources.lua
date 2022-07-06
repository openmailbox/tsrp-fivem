local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Event.check_and_init()
end
AddEventHandler(Events.ON_RESOURCE_START, create)
