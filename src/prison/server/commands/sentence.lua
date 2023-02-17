-- Forward declarations
local is_valid_player,
      tell_player

local function cmd_sentence(source, args, raw_command)
    if not args[1] then
        tell_player(source, "Syntax: /sentence <player ID> - Send a player to prison.")
        return
    end

    if not is_valid_player(args[1]) then
        tell_player(source, "No player found with ID " .. args[1] .. ".")
        return
    end

    local player = tonumber(args[1])
    local ped    = GetPlayerPed(player)

    SetCurrentPedWeapon(ped, Weapons.UNARMED, true)

    TriggerClientEvent(Events.CREATE_PRISON_SENTENCE, player)

    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .."'.")
end
RegisterCommand("sentence", cmd_sentence, true)

-- @local
function is_valid_player(id)
    for _, p in ipairs(GetPlayers()) do
        if p == id then
            return true
        end
    end

    return false
end

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
