local function cmd_set_wanted(source, args, raw_command)
    local player = nil
    local stars  = tonumber(args[2])

    if not stars or stars < 0 then
        TellPlayer(source, "Syntax: /setwanted <player ID> <stars>")
        return
    end

    for _, p in ipairs(GetPlayers()) do
        if p == args[1] then
            player = p
            break
        end
    end

    if not player then
        TellPlayer(source, "No player found with ID " .. args[1] .. ".")
        return
    end

    SetPlayerWantedLevel(player, stars)

    TellPlayer(source, "Setting Wanted Level for Player " .. player .. " to " .. stars .. ".")

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'."
    })
end
RegisterCommand("setwanted", cmd_set_wanted, true)
