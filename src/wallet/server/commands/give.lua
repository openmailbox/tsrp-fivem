-- Forward declarations
local tell_player

local function cmd_give_cash(source, args, _)
    if not args[1] or not args[2] then
        tell_player(source, "Syntax: /givecash <player ID> <amount> - Give (or take) some cash to (or from) a player.")
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

    local amount = tonumber(args[2])

    if not amount or amount == 0 then
        tell_player(source, "Amount must be a positive or negative integer.")
        return
    end

    local balance = Wallet.adjust_cash(source, amount)
    local message = "Adjusted Player " .. player .. " (" .. GetPlayerName(player) .. ")'s wallet by $" .. amount .. " to new balance $" .. balance .. "."

    tell_player(source, message)
    Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") " .. string.lower(message) .. "\n")
end
RegisterCommand("givecash", cmd_give_cash, true)

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
