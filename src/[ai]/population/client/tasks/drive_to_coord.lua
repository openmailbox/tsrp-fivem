DriveToCoord = {}

TaskManager.Tasks[Tasks.DRIVE_TO_COORD] = DriveToCoord

function DriveToCoord.begin(entity, args)
    local location = GetRandomPointInCircle(args.location, 10.0)
    local x, y, z  = table.unpack(location)
    local vehicle  = GetVehiclePedIsIn(entity, false)

    Logging.log(Logging.DEBUG, "Tasking ".. entity .. " to drive to " .. location .. ".")

    TaskVehicleDriveToCoord(entity, vehicle, x, y, z, 30.0, 5.0, GetEntityModel(vehicle), DrivingStyles.RUSHED, 10.0, true)
end

function DriveToCoord.update(entity, _)
    return GetIsTaskActive(entity, 169) -- CTaskControlVehicle
end
