local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    SpawnManager.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
