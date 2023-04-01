local function cmd_save_vehicle(source, _, raw_command)
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

    local vehicle = PlayerVehicle.for_entity(entity)

    if not vehicle then
        vehicle = PlayerVehicle:new({
            player_id = source,
            entity    = entity,
            model     = GetEntityModel(entity) -- TODO: need to get the human name from client
        })

        vehicle:initialize()
    end

    vehicle:save()

    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
end
RegisterCommand("savevehicle", cmd_save_vehicle, true)
