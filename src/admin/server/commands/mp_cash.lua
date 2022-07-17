local function cmd_set_wallet(source, args, raw_command)
    if not args[1] or not args[2] then
        TellPlayer(source, "Syntax: /setcash <player ID> <amount> - Set a player's wallet balance.")
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

    if not amount or amount < 1 then
        TellPlayer(source, "Wallet balance must be an integer greater than 0.")
        return
    end

    TriggerClientEvent(Events.UPDATE_MP_CASH_BALANCE, player, {
        amount = amount
    })

    local message = "Set Player " .. player .. " (" .. GetPlayerName(player) .. ")'s wallet balance to " .. amount .. "."

    TellPlayer(source, message)
    Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") " .. string.lower(message) .. "\n")
end
RegisterCommand("setcash", cmd_set_wallet, true)
