FollowEntity = {}

TaskManager.Tasks[Tasks.FOLLOW_TO_OFFSET_OF_ENTITY] = FollowEntity

local next_report_at = 0

function FollowEntity.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.TRACE, "Tasking " .. entity .. " to follow " .. target .. ".")

    TaskFollowToOffsetOfEntity(entity, target, 1.0, 1.0, 0.2, 2.0, -1, 10.0, true)
end

function FollowEntity.update(entity, args)
    if not NetworkDoesEntityExistWithNetworkId(args.target) then
        return false
    end

    local target = NetToPed(args.target)
    local time   = GetGameTimer()

    if target == PlayerPedId() and GetPlayerWantedLevel(PlayerId()) > 0 and time > next_report_at and HasEntityClearLosToEntity(entity, target, 17) then
        next_report_at = time + 10000
        ReportPoliceSpottedPlayer(PlayerId())

        if IsPedInAnyVehicle(target, false) then
            SetVehicleIsWanted(GetVehiclePedIsIn(target, false), true)
        end
    end

    return GetIsTaskActive(entity, 259) -- CTaskMoveFollowEntityOffset
end
