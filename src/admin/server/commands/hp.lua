local function cmd_adjust_hp(source, args, raw_command)
    local target = nil
    local amount = tonumber(args[2])

    if not amount or amount < 1 then
        TellPlayer(source, "Adjustment must be a positive integer.")
        return
    end

    for _, player in ipairs(GetPlayers()) do
        if player == args[1] then
            target = player
            break
        end
    end

    if not target then
        TellPlayer(source, "No connected player with ID '" .. tostring(args[1]) .. "'.")
        return
    end

    if string.match(raw_command, "heal") then
        amount = amount * -1 -- b/c we're using ApplyDamage() client side
    end

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'."
    })

    TriggerClientEvent(Events.CREATE_ADMIN_HP_ADJUST, target, {
        amount = amount
    })
end
RegisterCommand("hurt", cmd_adjust_hp, true)
RegisterCommand("heal", cmd_adjust_hp, true)
