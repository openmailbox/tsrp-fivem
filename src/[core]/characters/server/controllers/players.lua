local function on_disconnect(reason)
    local player_id = source
    local character = Character.for_player(player_id)

    if character then
        character:deactivate()
        Logging.log(Logging.INFO, "Unloading Character " .. character.id .. " (" .. character.first_name .. " " .. character.last_name ..
                                  ") for Player " .. player_id .. " (" .. GetPlayerName(player_id) .. "). Reason: '" .. reason .. "'.")
    end
end
AddEventHandler(Events.ON_PLAYER_DROPPED, on_disconnect)
