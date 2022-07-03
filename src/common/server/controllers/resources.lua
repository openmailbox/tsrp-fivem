local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Citizen.Trace("WARNING: This resource is not meant to be run directly.\n")
end
AddEventHandler(Events.ON_RESOURCE_START, create)
