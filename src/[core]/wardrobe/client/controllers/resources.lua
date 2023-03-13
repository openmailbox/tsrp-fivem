local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    Store.initialize()

    for type, details in pairs(RentLocations) do
        for _, loc in ipairs(details.locations) do
            Store.add({
                category = type,
                blip     = details.blip,
                name     = loc.name,
                location = loc.location,
                radius   = loc.radius
            })
        end
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Store.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
