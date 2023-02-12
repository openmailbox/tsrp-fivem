DriveToCoord = {}

TaskManager.Tasks[Tasks.DRIVE_TO_COORD] = DriveToCoord

function DriveToCoord.begin(entity, args)
    local location = GetRandomPointInCircle(args.location, 7.0)
    local x, y, z  = table.unpack(location)
    local vehicle  = GetVehiclePedIsIn(entity, false)

    Logging.log(Logging.DEBUG, "Telling ".. entity .. " to drive to " .. location .. ".")

    TaskVehicleDriveToCoord(entity, vehicle, x, y, z, 70.0, 10.0, GetEntityModel(vehicle), 16777216, 2.0, true)
end

function DriveToCoord.update(_, _)
    return false
end
