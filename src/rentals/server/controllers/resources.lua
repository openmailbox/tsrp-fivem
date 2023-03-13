local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    RentalVehicle.teardown()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
