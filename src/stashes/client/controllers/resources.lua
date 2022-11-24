local BLIP_LABEL = "Lester's House"
local BLIP_LOC   = vector3(1275.7319, -1710.5321, 54.7714)

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    TriggerServerEvent(Events.GET_STASHES)

    exports.map:AddBlip(BLIP_LABEL, BLIP_LOC, {
        icon  = 77,
        color = 47
    })
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    Stash.cleanup()

    exports.map:RemoveBlip(BLIP_LABEL)
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
