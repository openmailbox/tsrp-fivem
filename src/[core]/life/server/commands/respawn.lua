-- Forward declarations
local tell_player

local function cmd_respawn(source, args, _)
    if not args[1] then
        tell_player(source, "Syntax: /respawn <player ID> - Immediately force a player to respawn.")
        return
    end

    local player = nil

    for _, p in ipairs(GetPlayers()) do
        if p == args[1] then
            player = p
            break
        end
    end

    if not player then
        tell_player(source, "No player found with ID " .. args[1] .. ".")
        return
    end

    TriggerClientEvent(Events.CREATE_RESPAWN, source)
end
RegisterCommand("respawn", cmd_respawn, true)

-- @local
 function tell_player(player, message)
    if not player or player == 0 then
        Citizen.Trance(message .. "\n")
        return
    end

    TriggerClientEvent(Events.ADD_CHAT_MESSAGE, player, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), message }
    })
end