local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    Dealer.setup()
    Impound.setup()
    PlayerVehicle.setup()
    Renter.setup()

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/dopen", "Open a vehicle door.", {
        { name = "door", help = "number of the door starting at 0 for driver or 'all'" }
    })

    TriggerEvent(Events.ADD_CHAT_SUGGESTION, "/dclose", "Close a vehicle door.", {
        { name = "door", help = "number of the door starting at 0 for driver or 'all'" }
    })
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    Dealer.teardown()
    Impound.teardown()
    PlayerVehicle.teardown()
    Renter.teardown()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
