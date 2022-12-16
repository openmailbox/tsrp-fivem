local function cmd_wardrobe(source, args, raw_command)
    TriggerClientEvent(Events.CREATE_WARDROBE_SESSION, source, {
        filter = args[1]
    })

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'."
    })
end
RegisterCommand("wardrobe", cmd_wardrobe, true)
