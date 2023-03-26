local MODULES = {
    Dealer,
    Impound,
    PlayerVehicle,
    Renter
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for _, module in ipairs(MODULES) do
        module.setup()
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for _, module in ipairs(MODULES) do
        module.teardown()
    end
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
