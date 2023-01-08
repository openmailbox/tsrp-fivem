local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for i, data in ipairs(HeistLocations) do
        local heist = Heist:new(data)

        heist.id = i

        heist:initialize()
    end

    -- Control var just in case we're restarting this live and have connected clients
    HeistLocations.ready = true
end
AddEventHandler(Events.ON_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Heist.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
