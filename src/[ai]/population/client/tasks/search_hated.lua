SearchHated = {}

TaskManager.Tasks[Tasks.SEARCH_FOR_HATED_IN_AREA] = SearchHated

-- Forward declarations
local find_first_visible_enemy

function SearchHated.begin(entity, args)
    local location = GetRandomPointInCircle(args.location, 10.0)
    local x, y, z  = table.unpack(location)

    Logging.log(Logging.TRACE, "Tasking ".. entity .. " to search for hated entities near " .. location .. ".")

    SetCurrentPedWeapon(entity, GetBestPedWeapon(entity, 0))

    if not IsPedInFlyingVehicle(entity) then
        TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 5.0, 0.0, true, 16, 1, -957453492)
    end

    SearchHated.update(entity, args)
end

function SearchHated.update(entity, args)
    local target = find_first_visible_enemy(entity, args.location)
    if target == 0 then return end

    TaskManager.buffer_update({
        task_id = Tasks.SEARCH_FOR_HATED_IN_AREA,
        entity  = PedToNet(entity),
        target  = PedToNet(target)
    })

    return GetIsTaskActive(entity, 230) -- 230 = CTaskGoToPointAiming
end

-- @local
function find_first_visible_enemy(entity, destination)
    for _, ped in ipairs(GetGamePool("CPed")) do
        if ped > 0 and
            DoesEntityExist(ped) and
            GetPedType(ped) ~= 28 and
            GetRelationshipBetweenPeds(entity, ped) >= 4 and
            HasEntityClearLosToEntity(entity, ped, 17) and
            Vdist(destination, GetEntityCoords(ped)) < 20.0 and
            NetworkGetEntityIsNetworked(entity) then

            return ped
        end
    end

    return 0
end
