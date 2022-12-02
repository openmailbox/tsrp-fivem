BlipManager = {}

-- Forward declarations
local initialize_blip

local blips = {} -- All blips on the player's map

function BlipManager.add_blip(coords, options)
    local x, y, z = table.unpack(coords)
    local blip    = AddBlipForCoord(x, y, z)
    local uuid    = GenerateUUID()

    initialize_blip(blip, options)

    table.insert(blips, {
        blip = blip,
        id   = uuid
    })

    return uuid
end
exports("AddBlip", BlipManager.add_blip)

function BlipManager.remove_blip(id)
    for i, b in ipairs(blips) do
        if b.id == id then
            RemoveBlip(b.blip)
            table.remove(blips, i)
            return true
        end
    end

    return false
end
exports("RemoveBlip", BlipManager.remove_blip)

function BlipManager.start_entity_tracking(entity, options)
    for _, blip in ipairs(blips) do
        if blip.entity == entity then
            return false
        end
    end

    local blip = AddBlipForEntity(entity)
    local uuid = GenerateUUID()

    initialize_blip(blip, options)

    table.insert(blips, {
        entity = entity,
        blip   = blip,
        id     = uuid
    })

    return uuid
end
exports("StartEntityTracking", BlipManager.start_entity_tracking)

function BlipManager.stop_entity_tracking(entity)
    for i, b in ipairs(blips) do
        if b.entity == entity then
            RemoveBlip(b.blip)
            table.remove(blips, i)
            return true
        end
    end

    return false
end
exports("StopEntityTracking", BlipManager.stop_entity_tracking)

-- @local
function initialize_blip(blip, options)
    SetBlipSprite(blip, options.icon or 1)
    SetBlipColour(blip, options.color or 0)
    SetBlipDisplay(blip, options.display or 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(options.label)
    EndTextCommandSetBlipName(blip)
end
