GotoWhileAiming = {}

TaskManager.Tasks[Tasks.GOTO_COORD_WHILE_AIMING] = GotoWhileAiming

function GotoWhileAiming.begin(entity, args)
    local x, y, z = table.unpack(args.location)

    Logging.log(Logging.DEBUG, "Tasking ".. entity .. " to goto while aiming at " .. args.location .. ".")

    TaskGoToCoordWhileAimingAtCoord(entity, x, y, z, x, y, z, 2.0, false, 2.0, 0.5, false, 0, false, -957453492)
end

function GotoWhileAiming.update(entity, args)
    local target = NetToPed(args.target)

    if HasEntityClearLosToEntity(entity, target, 17) then
        TaskManager.buffer_update({
            task_id  = Tasks.AIM_AT_ENTITY,
            entity   = PedToNet(entity),
            in_range = true
        })
    end

    return GetIsTaskActive(entity, 230) -- CTaskGoToPointAiming
end
