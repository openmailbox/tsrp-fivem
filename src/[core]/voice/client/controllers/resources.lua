local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    if MumbleIsConnected() then
        MumbleSetTalkerProximity(10.0)
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
