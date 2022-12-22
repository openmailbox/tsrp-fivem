local function cmd_swap(source, _, raw_command)
    TriggerClientEvent(Events.CREATE_CHARACTER_SELECT_SESSION, source)

    TriggerEvent(Events.LOG_MESSAGE, {
        level = Logging.INFO,
        message = GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'."
    })
end
RegisterCommand("swap", cmd_swap, true)
