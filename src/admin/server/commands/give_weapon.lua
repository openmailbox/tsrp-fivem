local function cmd_give_weapon(source, args, _)
    if not args[1] or not args[2] then
        TellPlayer(source, "Syntax: /giveweapon <player ID> <name> - Give a weapon to a player.")
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

    GiveWeaponToPed(GetPlayerPed(source), weapon, 0, false, false)

    local message = "gave weapon '" .. name .. "' to Player " .. player .. " (" .. GetPlayerName(player) .. ")."

    TellPlayer(source, "You " .. message)
    Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") " .. message .. "\n")
end
RegisterCommand("giveweapon", cmd_give_weapon, true)
