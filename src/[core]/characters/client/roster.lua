Roster = {}

-- Forward declarations
local get_character_from_entity,
      look_for_selection,
      raycast_from_pointer

local POSITIONS = {
    {
        coords    = vector4(-803.1011, 171.6763, 72.8446, 299.0097),
        animation = { dictionary = "timetable@ron@ig_3_couch", name = "base" }
    },
    {
        coords    = vector4(-804.0355, 174.7156, 72.8446, 242.4243),
        animation = { dictionary = "timetable@ron@ig_5_p3", name = "ig_5_p3_base" }
    }
}

local characters = {}    -- all of the player's avaialable characters
local is_active  = false -- true during active selection mode
local selected   = nil   -- currently selected character

function Roster.cleanup()
    is_active = false

    for _, char in ipairs(characters) do
        char:remove()
    end

    characters = {}
end

function Roster.find_character(id)
    for _, char in ipairs(characters) do
        if char.id == id then
            return char
        end
    end

    return nil
end

function Roster.get_current_selection()
    return selected
end

function Roster.hide()
    is_active = false

    for _, c in ipairs(characters) do
        c:hide()
    end
end

function Roster.update(data)
    Roster.cleanup()

    for i, record in ipairs(data) do
        local char = Character:new(record)

        if POSITIONS[i] then
            char:assign_position(POSITIONS[i])
        else
            TriggerEvent(Events.LOG_MESSAGE, {
                level   = Logging.WARN,
                message = "Unable to find position for Character " .. char.id .. "."
            })
        end

        table.insert(characters, char)
    end

    look_for_selection()
end

-- @local
function get_character_from_entity(entity)
    for _, char in ipairs(characters) do
        if char.ped == entity then
            return char
        end
    end

    return nil
end

-- @local
function look_for_selection()
    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        local last_selection, entity, marker

        while is_active do
            entity   = raycast_from_pointer()
            selected = entity and get_character_from_entity(entity)

            if marker and selected ~= last_selection then
                exports.markers:RemoveMarker(marker)
                marker = nil
            end

            if selected and selected ~= last_selection then
                marker = exports.markers:AddMarker({
                    icon        = 2,
                    coords      = GetEntityCoords(entity) + vector3(0, 0, 0.5),
                    face_camera = true,
                    rotation    = vector3(180, 0, 0),
                    scale       = vector3(0.2, 0.2, 0.2),
                    bob         = true,
                    red         = 255,
                    green       = 255,
                    blue        = 0
                })
            end

            last_selection = selected

            Citizen.Wait(50)
        end

        if marker then
            exports.markers:RemoveMarker(marker)
        end
    end)
end

-- @local
function raycast_from_pointer()
    local screenX = GetDisabledControlNormal(0, 239)
    local screenY = GetDisabledControlNormal(0, 240)

    local world, normal = GetWorldCoordFromScreenCoord(screenX, screenY)
    local origin        = world + normal * 0.5
    local target        = world + normal * 5
    local ray           = StartShapeTestCapsule(origin.x, origin.y, origin.z, target.x, target.y, target.z, 0.2, 8, 0, 7)

    local result, hit, _, _, entity = GetShapeTestResult(ray)
    while result == 1 do
        Citizen.Wait(0)
    end

    if hit and entity > 0 then
        return entity
    else
        return nil
    end
end
