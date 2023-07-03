-- Forward declarations
local chat

local function toggle_door(_, args, raw_command)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle == 0 then
        chat("You must be driving a vehicle.")
        return
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then
        chat("You must be driving the vehicle.")
        return
    end

    local command, _ = raw_command:match("(%w+)(.*)")

    if not args[1] then
        chat("Syntax: " .. command .. " <number> or 'all' - Open a vehicle door.")
        return
    end

    local door       = tonumber(args[1])
    local door_count = GetNumberOfVehicleDoors(vehicle)

    if args[1] ~= "all" and (door < 0 or door >= door_count) then
        chat("This vehicle only has " .. door_count .. " doors.")
        return
    end

    local start, finish

    if args[1] == "all" then
        start  = 0
        finish = door_count - 1
    else
        start  = door
        finish = door
    end

    for i = start, finish do
        if command == "dopen" then
            SetVehicleDoorOpen(vehicle, i, false, true)
        else
            SetVehicleDoorShut(vehicle, i, false)
        end

        Citizen.Wait(1) -- seems to need this when running in a loop?
    end
end
RegisterCommand("dopen", toggle_door, false)
RegisterCommand("dclose", toggle_door, false)

-- @local
function chat(message)
    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), message }
    })
end
