local function on_disconnect(_)
    local player_id = source
    Keyring.cleanup(player_id)
end
AddEventHandler(Events.ON_PLAYER_DROPPED, on_disconnect)
