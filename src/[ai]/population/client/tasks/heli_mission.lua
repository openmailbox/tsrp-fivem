HeliMission = {}

TaskManager.Tasks[Tasks.HELI_MISSION] = HeliMission

function HeliMission.begin(entity, args)
    local vehicle = GetVehiclePedIsIn(entity, false)
    local target  = NetToPed(args.target)
    local x, y, z = table.unpack(GetEntityCoords(target))

    Logging.log(Logging.TRACE, "Tasking " .. entity .. " in helicopter " .. vehicle .. " to chase " .. target .. ".")

    TaskHeliChase(entity, target, 10.0, 10.0, 10.0)
    --TaskHeliMission(entity, vehicle, GetVehiclePedIsIn(target, false), target, x, y, z, 9, 1.0, -1.0, -1.0, 10, 10, 5.0, 0)
end

function HeliMission.update(entity, args)
    if not NetworkDoesEntityExistWithNetworkId(args.target) then
        return false
    end

    return GetIsTaskActive(entity, 12) -- CTaskVehicleMissionBase
end
