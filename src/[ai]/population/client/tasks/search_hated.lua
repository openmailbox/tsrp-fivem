SearchHated = {}

TaskManager.Tasks[Tasks.SEARCH_FOR_HATED_IN_AREA] = SearchHated

-- Forward declarations
local find_first_visible_enemy

function SearchHated.begin(entity, args)
    local location = GetRandomPointInCircle(args.location, 10.0)
    local x, y, z  = table.unpack(location)

    Logging.log(Logging.DEBUG, "Tasking ".. entity .. " to search for hated entities near " .. location .. ".")

    SetCurrentPedWeapon(entity, GetBestPedWeapon(entity, 0))
    TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 3.0, 0.0, true, 16, 1, -957453492)

    SearchHated.update(entity, args)
end

function SearchHated.update(entity, _)
    local target = find_first_visible_enemy(entity)
    if not target then return end

    TaskManager.buffer_update({
        task_id = Tasks.SEARCH_FOR_HATED_IN_AREA,
        entity  = PedToNet(entity),
        target  = PedToNet(target)
    })

    return GetIsTaskActive(entity, 230) -- CTaskGoToPointAiming
end

-- @local
function find_first_visible_enemy(entity)
    for _, ped in ipairs(GetGamePool("CPed")) do
        if GetRelationshipBetweenPeds(entity, ped) >= 4 and HasEntityClearLosToEntity(entity, ped) then
            return ped
        end
    end

    return nil
end
