local function cmd_set_ammo(source, args, _)
    if not args[1] or not args[2] or not args[3] then
        TellPlayer(source, "Syntax: /setammo <player ID> <name> <amount> - Give ammo to a player for a weapon.")
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

    local name   = string.upper(args[2])
    local weapon = Weapons[name]

    if not weapon then
        TellPlayer(source, "No such weapon named '" .. name .. "'.")
        return
    end

    local amount = math.max(tonumber(args[3]), 0)

    SetPedAmmo(GetPlayerPed(player), weapon, amount)

    local message = "set ammo to " .. amount .. " for '" .. name .. "' on Player " .. player .. " (" .. GetPlayerName(player) .. ")."

    TellPlayer(source, "You " .. message)
    Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") " .. message .. "\n")
end
RegisterCommand("setammo", cmd_set_ammo, true)