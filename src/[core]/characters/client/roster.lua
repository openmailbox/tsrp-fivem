Roster = {}

-- Forward declarations
local get_closest_character,
      look_for_selection

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

        char:assign_position(POSITIONS[i])

        table.insert(characters, char)
    end

    look_for_selection()
end

-- @local
function get_closest_character(coords)
    local closest  = nil
    local distance = 0.6
    local dist

    for _, char in ipairs(characters) do
        dist = Vdist(GetEntityCoords(char.ped), coords)
        if dist < distance then
            distance = dist
            closest  = char
        end
    end

    return closest
end

-- @local
function look_for_selection()
    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        local character, last_char, marker, normal, screenX, screenY, world

        local depth = 4

        while is_active do
            screenX = GetDisabledControlNormal(0, 239)
            screenY = GetDisabledControlNormal(0, 240)

            world, normal = GetWorldCoordFromScreenCoord(screenX, screenY)
            character     = get_closest_character(world + normal * depth)

            if marker and character ~= last_char then
                exports.markers:RemoveMarker(marker)
                marker = nil
            end

            if character and character ~= last_char then
                marker = exports.markers:AddMarker({
                    icon        = 2,
                    coords      = GetEntityCoords(character.ped) + vector3(0, 0, 0.5),
                    face_camera = true,
                    rotation    = vector3(180, 0, 0),
                    scale       = vector3(0.2, 0.2, 0.2),
                    bob         = true,
                    red         = 255,
                    green       = 255,
                    blue        = 0
                })
            end

            last_char = character

            Citizen.Wait(100)
        end

        if marker then
            exports.marker:RemoveMarker(marker)
        end
    end)
end
