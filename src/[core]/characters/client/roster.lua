Roster = {}

-- Measurements in pixels for calculating selected character from mouse position
local BOUNDING = {
    width  = 200,
    height = 400,
    offset = vector2(0, 300)
}

-- Forward declarations
local get_intersecting_member,
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
function get_intersecting_member(p, boxes)
    for i, rect in ipairs(boxes) do
        if p.x > rect.min.x and p.x < rect.max.x and
            p.y > rect.min.y and p.y < rect.max.y then

            return i, boxes[i]
        end
    end

    return nil
end

-- @local
function look_for_selection()
    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        local character, index, last_char, marker, mouseXY

        local ped_boxes   = {}
        local resx, resy  = GetActiveScreenResolution()
        local half_width  = BOUNDING.width / 2
        local half_height = BOUNDING.width / 2

        for _, char in ipairs(characters) do
            local px, py, pz = table.unpack(GetEntityCoords(char.ped))
            local _, x, y    = GetScreenCoordFromWorldCoord(px, py, pz)
            local cloc       = vector2(x * resx, y * resy) + BOUNDING.offset

            local rect = {
                min = vector2(cloc.x - half_width, cloc.y - half_height),
                max = vector2(cloc.x + half_width, cloc.y + half_height),
            }

            table.insert(ped_boxes, rect)
        end

        while is_active do
            mouseXY   = vector2(GetDisabledControlNormal(0, 239) * resx, GetDisabledControlNormal(0, 240) * resy)
            index     = get_intersecting_member(mouseXY, ped_boxes)
            character = characters[index]

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
