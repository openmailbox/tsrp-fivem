local function cmd_spawn_cash(source, args, _)
    if not args[1] or not args[2] then
        TellPlayer(source, "Syntax: /spawncash <player ID> <amount> - Spawn collectable cash for a player.")
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
        TellPlayer(source, "No player found with ID " .. args[1] .. ".")
        return
    end

    local amount = tonumber(args[2])

    if amount < 1 then
        TellPlayer(source, "Amount must be a positive integer.")
        return
    end

    TriggerClientEvent(Events.CREATE_CASH_PICKUP, player, {
        amount   = amount,
        location = GetEntityCoords(GetPlayerPed(source)),
        timeout  = 3 -- number of seconds before player can collect the spawned cash
    })
end
RegisterCommand("spawncash", cmd_spawn_cash, true)
