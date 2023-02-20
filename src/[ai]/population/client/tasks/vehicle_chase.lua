VehicleChase = {}

TaskManager.Tasks[Tasks.VEHICLE_CHASE] = VehicleChase

function VehicleChase.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.TRACE, "Tasking " .. entity .. " in vehicle " .. GetVehiclePedIsIn(entity) .. " to chase " .. target .. ".")

    TaskVehicleChase(entity, target)
end

function VehicleChase.update(entity, _)
    return GetIsTaskActive(entity, 363) -- CTaskVehicleChase
end
