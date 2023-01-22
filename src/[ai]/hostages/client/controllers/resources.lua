local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Following.initialize()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
