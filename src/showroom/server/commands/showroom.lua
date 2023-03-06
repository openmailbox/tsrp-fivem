local function cmd_showroom(source, _, raw_command)
    TriggerClientEvent(Events.CREATE_SHOWROOM_SESSION, source, { })
    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
end
RegisterCommand("showroom", cmd_showroom, true)
