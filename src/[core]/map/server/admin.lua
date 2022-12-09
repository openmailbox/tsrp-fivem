local function cmd_vspawn(source, args, raw_command)
    TriggerClientEvent(Events.CREATE_MAP_VSPAWN_RESULT, source, {
        model = string.lower(tostring(args[1]))
    })

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'."
    })
end
RegisterCommand("vspawn", cmd_vspawn, true)
