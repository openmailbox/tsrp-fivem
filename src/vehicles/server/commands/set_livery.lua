local function cmd_set_livery(source, args, raw_command)
    local ped    = GetPlayerPed(source)
    local entity = GetVehiclePedIsIn(ped, false)

    if entity == 0 then
        TriggerClientEvent(Events.ADD_CHAT_MESSAGE, source, {
            color     = Colors.RED,
            multiline = true,
            args      = { GetCurrentResourceName(), "Must be inside a vehicle." }
        })
        return
    end

    local owner = NetworkGetEntityOwner(entity)

    TriggerClientEvent(Events.UPDATE_VEHICLE_LIVERY, owner, {
        value = args[1]
    })

    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
end
RegisterCommand("setlivery", cmd_set_livery, true)
