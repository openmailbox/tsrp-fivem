SearchHated = {}

TaskManager.Tasks[Tasks.SEARCH_FOR_HATED_IN_AREA] = SearchHated

-- Forward declarations
local find_best_enemy,
      is_valid_enemy

local target = 0

local targets = {}

function SearchHated.begin(entity, args)
    local location = args.location

    if Vdist(args.location, GetEntityCoords(entity)) < 3.0 then
        location = GetRandomPointInCircle(args.location, 10.0)
    end

    local x, y, z  = table.unpack(location)

    Logging.log(Logging.TRACE, "Tasking ".. entity .. " to search for hated entities near " .. location .. ".")

    SetCurrentPedWeapon(entity, GetBestPedWeapon(entity, 0))

    if not IsPedInFlyingVehicle(entity) then
        TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 2.0, 0.0, true, 16, 1, -957453492)
    end

    SearchHated.update(entity, args)
end

function SearchHated.update(entity, args)
    local new_target = find_best_enemy(entity, args.location)

    if new_target > 0 and new_target ~= targets[entity] then
        targets[entity] = new_target

        TaskManager.buffer_update({
            task_id  = Tasks.SEARCH_FOR_HATED_IN_AREA,
            entity   = PedToNet(entity),
            target   = PedToNet(new_target),
            location = GetEntityCoords(new_target)
        })
    end

    return GetIsTaskActive(entity, 230) -- 230 = CTaskGoToPointAiming
end

-- @local
function find_best_enemy(entity, destination)
    for _, ped in ipairs(GetGamePool("CPed")) do
        if ped > 0 and
            IsPedAPlayer(ped) and
            is_valid_enemy(entity, ped) and
            HasEntityClearLosToEntity(entity, ped, 17) and
            Vdist(destination, GetEntityCoords(ped)) < 20.0 then

            return ped
        end
    end

    return 0
end

-- @local
function is_valid_enemy(entity, ped)
    return DoesEntityExist(ped) and
        GetPedType(ped) ~= 28 and
        GetRelationshipBetweenPeds(entity, ped) >= 4 and -- returns players w/ wanted stars
        NetworkGetEntityIsNetworked(entity)
end
