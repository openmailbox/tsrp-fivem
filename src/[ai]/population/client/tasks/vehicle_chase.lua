VehicleChase = {}

TaskManager.Tasks[Tasks.VEHICLE_CHASE] = VehicleChase

local next_report_at = 0

function VehicleChase.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.TRACE, "Tasking " .. entity .. " in vehicle " .. GetVehiclePedIsIn(entity) .. " to chase " .. target .. ".")

    TaskVehicleChase(entity, target)
end

function VehicleChase.update(entity, args)
    if not NetworkDoesEntityExistWithNetworkId(args.target) then
        return
    end

    local target = NetToPed(args.target)
    local time   = GetGameTimer()

    if target == PlayerPedId() and GetPlayerWantedLevel(PlayerId()) > 0 and time > next_report_at and HasEntityClearLosToEntity(entity, target, 17) then
        next_report_at = time + 10000

        ReportPoliceSpottedPlayer(PlayerId())
        SetVehicleIsWanted(GetVehiclePedIsIn(target, false), true)
    end

    return GetIsTaskActive(entity, 363) -- CTaskVehicleChase
end
