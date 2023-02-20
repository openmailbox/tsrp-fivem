AimAtEntity = {}

TaskManager.Tasks[Tasks.AIM_AT_ENTITY] = AimAtEntity

-- Forward declarations
local are_hands_raised,
      get_closest_cop

local Animation = { DICTIONARY = "ped", NAME = "handsup_base", DOWN = "handsup_exit" }

function AimAtEntity.begin(entity, args)
    local target     = NetToPed(args.target)
    local my_vehicle = GetVehiclePedIsIn(entity, false)

    if IsPedInAnyVehicle(entity, false) and not IsPedInFlyingVehicle(entity) then
        TaskLeaveVehicle(entity, my_vehicle, 0)

        repeat
            Citizen.Wait(10)
        until not IsPedInAnyVehicle(entity, false)
    end

    -- Only heli drivers should be ineligible
    if not IsPedInAnyVehicle(entity) or GetPedInVehicleSeat(my_vehicle, -1) ~= entity then
        Logging.log(Logging.TRACE, "Tasking " .. entity .. " to aim at " .. target .. ".")
        TaskAimGunAtEntity(entity, target, -1, 0)
    end
end

function AimAtEntity.update(entity, args)
    if not NetworkDoesEntityExistWithNetworkId(args.target) then
        return false
    end

    if not GetIsTaskActive(entity, 4) and not GetIsTaskActive(entity, 230) then
        return false
    end

    if IsPedInFlyingVehicle(entity) then
        return true
    end

    local target     = NetToPed(args.target)
    local target_loc = GetEntityCoords(target)
    local entity_loc = GetEntityCoords(entity)

    if not IsPedInAnyVehicle(target, false) and are_hands_raised(target) and get_closest_cop(entity, target_loc) == entity then
        TaskManager.buffer_update({
            task_id      = Tasks.AIM_AT_ENTITY,
            entity       = PedToNet(entity),
            surrendering = true,
            offset       = target_loc + (GetEntityForwardVector(target) * 1.2)
        })
        return false
    end

    local max_range = math.ceil(GetMaxRangeOfCurrentPedWeapon(entity) / 3)
    local in_range  = HasEntityClearLosToEntity(entity, target, 17) and Vdist(target_loc, entity_loc) < max_range

    if not in_range and not GetIsTaskActive(entity, 230) then
        Logging.log(Logging.TRACE, "Tasking " .. entity .. " to get within " .. max_range .. " of " .. target .. ".")
        TaskGoToEntityWhileAimingAtEntity(entity, target, target, 2.0, false, 2.0, 0.5, false, 0, -957453492)
    end

    return true
end

-- @local
function are_hands_raised(entity)
    return IsEntityPlayingAnim(entity, Animation.DICTIONARY, Animation.NAME, 3)
end

-- @local
function get_closest_cop(myself, location)
    local closest, distance

    if GetPedType(myself) ~= 6 then
        return false
    else
        closest  = myself
        distance = Vdist2(GetEntityCoords(myself), location)
    end

    local d

    for _, ped in ipairs(GetGamePool("CPed")) do
        if ped ~= myself and GetPedType(ped) == 6 then
            d = Vdist2(GetEntityCoords(ped), location)

            if d < distance then
                distance = d
                closest  = ped
            end
        end
    end

    return closest
end
