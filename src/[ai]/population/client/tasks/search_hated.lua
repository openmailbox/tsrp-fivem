SearchHated = {}

TaskManager.Tasks[Tasks.SEARCH_FOR_HATED_IN_AREA] = SearchHated

-- Forward declarations
local find_first_visible_enemy,
      get_rand_point_in_circle

local next_at   = 0
local ped_pool  = {}

function SearchHated.begin(entity, args)
    local location = get_rand_point_in_circle(args.location, 7.0)
    local x, y, z  = table.unpack(location)

    Logging.log(Logging.DEBUG, "Tasking ".. entity .. " to search for hated entities near " .. location .. ".")

    TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 3.0, 0.0, true, 16, 1, -957453492)

    SearchHated.update(entity, args)
end

function SearchHated.update(entity, _)
    if GetGameTimer() > next_at then
        ped_pool = GetGamePool("CPed")
        next_at  = GetGameTimer() + 2000
    end

    -- TODO: Better way to tell if we're still doing the task
    if GetEntitySpeed(entity) == 0.0 then
        return false
    end

    local target = find_first_visible_enemy(entity)
    if not target then return end

    TaskManager.buffer_update({
        task_id   = Tasks.SEARCH_FOR_HATED_IN_AREA,
        aggressor = PedToNet(entity),
        target    = PedToNet(target)
    })
end

-- @local
function get_rand_point_in_circle(origin, r)
    local angle  = math.random() * math.pi * 2
    local radius = math.sqrt(math.random()) * r
    local x      = origin.x + radius * math.cos(angle)
    local y      = origin.y + radius * math.sin(angle)

    return vector3(x, y, origin.z)
end

-- @local
function find_first_visible_enemy(entity)
    for _, ped in ipairs(ped_pool) do
        if GetRelationshipBetweenPeds(entity, ped) >= 4 and HasEntityClearLosToEntity(entity, ped) then
            return ped
        end
    end

    return nil
end
