AimAtEntity = {}

TaskManager.Tasks[Tasks.AIM_AT_ENTITY] = AimAtEntity

function AimAtEntity.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.DEBUG, "Telling ".. entity .. " to aim at " .. target .. ".")

    TaskAimGunAtEntity(entity, target, -1, 0)
end

function AimAtEntity.update(entity, args)
    return false
end
