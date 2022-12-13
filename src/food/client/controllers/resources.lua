local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    if GetEntityHealth(PlayerPedId()) < GetEntityMaxHealth(PlayerPedId()) then
        Map.reveal_objects()
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Map.cleanup()
    Trash.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
