-- Forward declarations
local tell_player

local function cmd_spawn_weapon(source, args, raw_command)
    if not args[1] or not args[2] then
        tell_player(source, "Syntax: /spawnweapon <player ID> <amount> - Spawn a pickup weapon at player's location.")
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

    local name   = string.upper(args[2])
    local weapon = Weapons[name]

    if not weapon then
        tell_player(source, "No such weapon named '" .. name .. "'.")
        return
    end

    TriggerClientEvent(Events.CREATE_INVENTORY_WEAPON_PICKUP, player, {
        weapon   = weapon,
        location = GetEntityCoords(GetPlayerPed(source))
    })

    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")
end
RegisterCommand("spawnweapon", cmd_spawn_weapon, true)

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
