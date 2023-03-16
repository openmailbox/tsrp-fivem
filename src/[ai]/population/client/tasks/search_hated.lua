SearchHated = {}

TaskManager.Tasks[Tasks.SEARCH_FOR_HATED_IN_AREA] = SearchHated

-- Forward declarations
local find_best_enemy,
      is_valid_enemy

function SearchHated.begin(entity, args)
    local x, y, z  = table.unpack(args.location)

    Logging.log(Logging.TRACE, "Tasking ".. entity .. " to search for hated entities near " .. args.location .. ".")

    SetCurrentPedWeapon(entity, GetBestPedWeapon(entity, 0))

    if not IsPedInFlyingVehicle(entity) then
        TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 5.0, 0.0, true, 16, 1, -957453492)
    end

    SearchHated.update(entity, args)
end

function SearchHated.update(entity, args)
    local target = find_best_enemy(entity, args.location)
    if target == 0 then return end

    TaskManager.buffer_update({
        task_id  = Tasks.SEARCH_FOR_HATED_IN_AREA,
        entity   = PedToNet(entity),
        target   = PedToNet(target),
        location = GetEntityCoords(target)
    })

    return GetIsTaskActive(entity, 230) -- 230 = CTaskGoToPointAiming
end

-- @local
function find_best_enemy(entity, destination)
    local locals  = {}

    for _, ped in ipairs(GetGamePool("CPed")) do
        if ped > 0 and
            is_valid_enemy(entity, ped) and
            HasEntityClearLosToEntity(entity, ped, 17) and
            Vdist(destination, GetEntityCoords(ped)) < 20.0 then

            if IsPedAPlayer(ped) then
                return ped
            else
                table.insert(locals, ped)
            end
        end
    end

    if #locals > 0 then
        return locals[1]
    end

    return 0
end

-- @local
function is_valid_enemy(entity, ped)
    return DoesEntityExist(ped) and
        GetPedType(ped) ~= 28 and
        GetRelationshipBetweenPeds(entity, ped) >= 4 and
        NetworkGetEntityIsNetworked(entity)
end
