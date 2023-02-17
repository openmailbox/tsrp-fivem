AimAtEntity = {}

TaskManager.Tasks[Tasks.AIM_AT_ENTITY] = AimAtEntity

-- Forward declarations
local are_hands_raised,
      get_closest_cop

local Animation = { DICTIONARY = "ped", NAME = "handsup_base", DOWN = "handsup_exit" }

function AimAtEntity.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.DEBUG, "Telling ".. entity .. " to aim at " .. target .. ".")

    TaskAimGunAtEntity(entity, target, -1, 0)
end

function AimAtEntity.update(entity, args)
    local target   = NetToPed(args.target)
    local location = GetEntityCoords(target)

    if are_hands_raised(target) and get_closest_cop(entity, location) == entity then
        TaskManager.buffer_update({
            task_id = Tasks.AIM_AT_ENTITY,
            enactor = PedToNet(entity),
            target  = args.target
        })
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
