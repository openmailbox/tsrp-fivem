local function cmd_spawn_cash(source, args, _)
    if not source or source == 0 then
        Citizen.Trace("Invalid console command.\n")
        return
    end

    if not args[1] then
        TellPlayer(source, "Syntax: /spawncash <amount> - Spawn collectable cash.")
        return
    end

    local amount = tonumber(args[1])

    if amount < 1 then
        TellPlayer(source, "Amount must be a positive integer.")
        return
    end

    TriggerClientEvent(Events.CREATE_CASH_PICKUP, source, {
        amount   = tonumber(args[1]),
        location = GetEntityCoords(GetPlayerPed(source)),
        timeout  = 10 -- number of seconds before player can collect their own spawned cash
    })
end
RegisterCommand("spawncash", cmd_spawn_cash, true)
