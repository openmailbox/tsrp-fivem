BlipManager = {}

-- Forward declarations
local initialize_blip

local blips = {} -- All blips on the player's map

function BlipManager.add_blip(coords, options)
    local x, y, z = table.unpack(coords)
    local uuid    = GenerateUUID()
    local blip    = nil

    if options.radius then
        blip = AddBlipForRadius(x, y, z, options.radius)
    else
        blip = AddBlipForCoord(x, y, z)
    end

    initialize_blip(blip, options)

    table.insert(blips, {
        blip   = blip,
        id     = uuid,
        coords = coords
    })

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Added static blip for " .. coords .. " to the map."
    })

    return uuid
end
exports("AddBlip", BlipManager.add_blip)

function BlipManager.remove_blip(id)
    local removing = nil

    for i, b in ipairs(blips) do
        if b.id == id then
            removing = b
            table.remove(blips, i)
            break
        end
    end

    if not removing then
        return false
    end

    RemoveBlip(removing.blip)

    local message = "Removed blip from the map."

    if removing.coords then
        message = "Removed static blip from " .. removing.coords .. " on the map."
    elseif removing.entity then
        message = "Removed blip for Entity " .. removing.entity .. " from the map."
    end

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = message
    })

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

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Added tracked blip for Entity " .. entity .. " to the map."
    })

    return uuid
end
exports("StartEntityTracking", BlipManager.start_entity_tracking)

function BlipManager.stop_entity_tracking(entity)
    for i, b in ipairs(blips) do
        if b.entity == entity then
            RemoveBlip(b.blip)

            table.remove(blips, i)

            TriggerEvent(Events.LOG_MESSAGE, {
                level   = Logging.DEBUG,
                message = "Removed tracked blip for Entity " .. entity .. " from the map."
            })

            return true
        end
    end

    return false
end
exports("StopEntityTracking", BlipManager.stop_entity_tracking)

-- @local
function initialize_blip(blip, options)
    if options.icon then
        SetBlipSprite(blip, options.icon)
    end

    SetBlipColour(blip, options.color or 0)
    SetBlipDisplay(blip, options.display or 3)
    SetBlipAsShortRange(blip, not options.always_on)

    if options.alpha then
        SetBlipAlpha(blip, options.alpha)
    end

    if options.scale then
        SetBlipScale(blip, options.scale)
    end

    if options.label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(options.label)
        EndTextCommandSetBlipName(blip)
    end
end
