Roster = {}

-- Forward declarations
local look_for_selection

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

local characters = {}
local is_active  = false

function Roster.cleanup()
    is_active = false

    for _, char in ipairs(characters) do
        char:remove()
    end

    characters = {}
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
function look_for_selection()
    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        local entity, hit, last_entity, marker, normal, origin, ray, result, screenX, screenY, target, world

        while is_active do
            screenX = GetDisabledControlNormal(0, 239)
            screenY = GetDisabledControlNormal(0, 240)

            world, normal = GetWorldCoordFromScreenCoord(screenX, screenY)
            origin        = world + normal * 0.5
            target        = world + normal * 5
            ray           = StartShapeTestCapsule(origin.x, origin.y, origin.z, target.x, target.y, target.z, 0.2, 8, 0, 7)

            result, hit, _, _, entity = GetShapeTestResult(ray)
            while result == 1 do
                Citizen.Wait(0)
            end

            if marker and entity ~= last_entity then
                exports.markers:RemoveMarker(marker)
                marker = nil
            end

            if hit and entity > 0 and entity ~= last_entity then
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

            last_entity = entity

            Citizen.Wait(50)
        end

        if marker then
            exports.marker:RemoveMarker(marker)
        end
    end)
end
