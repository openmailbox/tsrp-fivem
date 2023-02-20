FollowEntity = {}

TaskManager.Tasks[Tasks.FOLLOW_TO_OFFSET_OF_ENTITY] = FollowEntity

function FollowEntity.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.TRACE, "Tasking " .. entity .. " to follow " .. target .. ".")

    TaskFollowToOffsetOfEntity(entity, target, 1.0, 1.0, 0.2, 2.0, -1, 10.0, true)
end

function FollowEntity.update(entity, args)
    if not NetworkDoesEntityExistWithNetworkId(args.target) then
        return false
    end

    return GetIsTaskActive(entity, 259) -- CTaskMoveFollowEntityOffset
end
