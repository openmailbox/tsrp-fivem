-- Forward declarations
local tell_player

local function cmd_log(source, args, raw_command)
    local message = args[1]

    if not message or string.len(message) < 1 then
        tell_player(source, "Syntax: /addlog <message> - Write an arbitrary message to logs.")
        return
    end

    Logging.log(Logging.INFO, message)

    TriggerEvent(Events.CREATE_DISCORD_LOG, message)

    if source > 0 then
        Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
    else
        Logging.log(Logging.INFO, "Console used command '" .. raw_command .. "'.")
    end
end
RegisterCommand("addlog", cmd_log, true)

-- @local
 function tell_player(player, message)
    if not player or player == 0 then
        Citizen.Trace(message .. "\n")
        return
    end

    TriggerClientEvent(Events.ADD_CHAT_MESSAGE, player, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), message }
    })
end