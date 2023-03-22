local function cmd_zshow(source, _, raw_command)
    TriggerClientEvent(Events.CREATE_VISIBLE_ZONES, source)
    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
end
RegisterCommand("zshow", cmd_zshow, true)

local function cmd_zhide(source, _, raw_command)
    TriggerClientEvent(Events.DELETE_VISIBLE_ZONES, source)
    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
end
RegisterCommand("zhide", cmd_zhide, true)
