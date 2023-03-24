local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Dealer.setup()
    Renter.setup()
    PlayerVehicle.setup()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Dealer.teardown()
    Renter.teardown()
    PlayerVehicle.teardown()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
