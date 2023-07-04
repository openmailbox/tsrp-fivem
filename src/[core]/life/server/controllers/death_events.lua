local function create(data)
    local player_id = source
    local character = exports.characters:GetPlayerCharacter(player_id)
    local name      = character.first_name .. " " .. character.last_name
    local message   = GetPlayerName(player_id) .. " (" .. player_id .. ") as " .. name .. " was killed"
    local killer    = data.killer_net_id and NetworkGetEntityFromNetworkId(data.killer_net_id)
    local weapon    = WeaponNames[data.weapon]

    if killer then
        message = message .. " by "

        if data.killer_player_id then
            local killer_char = exports.characters:GetPlayerCharacter(data.killer_player_id)
            message = message .. killer_char.first_name .. " " .. killer_char.last_name
        else
            message = message .. data.cause .. " " .. (killer or data.killer_net_id)
        end
    else
        message = message .. " by " .. data.cause
    end

    if weapon then
        message = message .. " using a " .. weapon

        if data.melee then
            message = message .. " (melee)"
        end
    end

    Logging.log(Logging.INFO, message .. ".", true)
end
RegisterNetEvent(Events.CREATE_DEATH_EVENT, create)
