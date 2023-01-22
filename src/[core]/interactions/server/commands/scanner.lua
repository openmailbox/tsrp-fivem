local function cmd_scanner(source, _, raw_command)
    TriggerClientEvent(Events.CREATE_SCANNER_TOGGLE, source)

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'."
    })
end
RegisterCommand("scanner", cmd_scanner, true)
