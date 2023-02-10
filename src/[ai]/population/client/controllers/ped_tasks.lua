-- Forward declarations
local get_search_point

local function drive_to_coord(data)
    local entity  = NetToPed(data.net_id)
    local x, y, z = table.unpack(get_search_point(data.location, 5.0))
    local vehicle = GetVehiclePedIsIn(entity, false)

    Logging.log(Logging.TRACE, "Telling ".. entity .. " to drive to " .. data.location)

    TaskVehicleDriveToCoord(entity, vehicle, x, y, z, 70.0, 10.0, GetEntityModel(vehicle), 16777216, 2.0, true)
end
RegisterNetEvent(Events.CREATE_POPULATION_TASK_DRIVE_TO_COORD, drive_to_coord)

local function search_hated(data)
    local entity  = NetToPed(data.net_id)
    local x, y, z = table.unpack(get_search_point(data.location, 10.0))

    Logging.log(Logging.TRACE, "Telling ".. entity .. " to search for hated entities near " .. data.location)

    TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 3.0, 0.0, true, 16, 1, -957453492)
end
RegisterNetEvent(Events.CREATE_POPULATION_TASK_SEARCH_HATED, search_hated)

-- @local
function get_search_point(origin, range)
    local angle  = math.random() * math.pi * 2
    local radius = math.sqrt(math.random()) * range
    local x      = origin.x + radius * math.cos(angle)
    local y      = origin.y + radius * math.sin(angle)

    return vector3(x, y, origin.z)
end
