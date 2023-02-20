HeliMission = {}

TaskManager.Tasks[Tasks.HELI_MISSION] = HeliMission

local next_report_at = 0

function HeliMission.begin(entity, args)
    local vehicle = GetVehiclePedIsIn(entity, false)
    local target  = NetToPed(args.target)
    local x, y, z = table.unpack(GetEntityCoords(target))

    if IsPedInAnyVehicle(target, false) then
        Logging.log(Logging.TRACE, "Tasking " .. entity .. " in helicopter " .. vehicle .. " to chase " .. target .. ".")
        TaskHeliChase(entity, target, 10.0, 10.0, 10.0)
    else
        Logging.log(Logging.TRACE, "Tasking " .. entity .. " in helicopter " .. vehicle .. " with heli mission on " .. target .. ".")
        TaskHeliMission(entity, vehicle, GetVehiclePedIsIn(target, false), target, x, y, z, 9, 1.0, -1.0, -1.0, 10, 10, 5.0, 0)
    end
end

function HeliMission.update(entity, args)
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

    return GetIsTaskActive(entity, 12) -- CTaskVehicleMissionBase
end
